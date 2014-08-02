module Clerk
  module Form
    class << self
      def print(form_identifier, fields = {}, options = {})
        raise NoAccount.new("CLERK_URL is not specified, did you install heroku add-on?") unless ENV['CLERK_URL']
        raise ArgumentError.new("form_identifier is required")                            unless form_identifier
        raise ArgumentError.new("fields must be a hash")                                  unless fields.is_a?(Hash)
        raise ArgumentError.new("options must be a hash")                                 unless options.is_a?(Hash)

        url               = ENV['CLERK_URL']
        headers           = {'Content-Type' => 'application/json'}
        headers['Accept'] = 'application/pdf' if options[:file]
        params            = {fields: fields}
        params[:test]     = true              if options[:test]

        http_client = Faraday.new(url: url, headers: headers)

        response = http_client.post "/api/forms/#{form_identifier}/printouts", params.to_json

        result, error = parse_response(response, options)

        if block_given?
          yield result, error
        else
          error ? raise(error) : result
        end
      end

      private

      def parse_response(response, options)
        if response.success?
          result = options[:file] ? prepare_file(response) : prepare_file_url(response)
          [result, nil]
        else
          [nil, parse_error(response)]
        end
      end

      def prepare_file(response)
        Fileless.new(response.body, "printout.pdf", "application/pdf")
      end

      def prepare_file_url(response)
        JSON.parse(response.body)['file_url']
      end

      def parse_error(response)
        case response.status
        when 400
          InvalidRequest.new("Invalid data, please verify fields. If it is correct please report issue to clerk support.")
        when 401
          InvalidToken.new("Authorization failed. Please verify CLERK_URL env variable and your account")
        when 404
          RecordNotFound.new("Form not found, check form identifier.")
        when 408
          RequestTimeout.new("Request timeout, verify connection and try again.")
        when 412
          CrossedLimit.new("Your monthly limit has been exceeded, please upgrade plan.")
        when 500
          InternalServerError.new("Something went wrong. There is a high chance that we already work on it.")
        when 503
          MaintenanceMode.new("Maintenance mode, please try again later.")
        end
      end
    end
  end
end