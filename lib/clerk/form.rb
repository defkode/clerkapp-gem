module Clerk
  class Form
    class NoAccount < StandardError; end
    class ApiError < StandardError; end

    attr_accessor :async, :test, :raise_on_error

    class << self
      def list(options = {})
        new(options).list
      end

      def print(form_identifier, fields = {}, options = {})
        new(options).print(form_identifier, fields)
      end
    end

    def initialize(options = {})
      raise NoAccount, "CLERK_URL is not specified, did you install heroku add-on?" unless ENV['CLERK_URL']
      raise ArgumentError.new("options must be a hash") unless options.is_a?(Hash)

      @test           = options.fetch("test", false)
      @async          = options.fetch("async", false)
      @raise_on_error = options.fetch("raise_on_error", true)
    end

    def print(form_identifier, fields = {})
      raise ArgumentError.new("form_identifier is required") unless form_identifier
      raise ArgumentError.new("fields must be a hash")       unless fields.is_a?(Hash)

      response = http_client.post "/api/printouts", {
        "form_identifier" => form_identifier,
        "fields"          => fields,
        "test"            => test,
        "async"           => async
      }.to_json

      if @raise_on_error && !response.success?
        raise ApiError.new("status_code: #{response.status}#{"\n#{response.body}" if response.body.present?}")
      end

      if !response.success?
        parsed(response)
      elsif async
        parsed(response)["ticket_id"]
      elsif block_given? # no need to load to memory
        return_value = nil
        Tempfile.open("clerkapp") do |f|
          f.sync = true
          f.write(response.body)
          f.rewind
          return_value = yield f, response
        end
        return_value
      else
        Fileless.new(response.body, "#{form_identifier}.pdf", 'application/pdf')
      end
    end

    def list
      response = http_client.get "/api/forms"
      if response.success?
        parsed(response)
      end
    end

    private

    def parsed(response)
      JSON.parse(response.body)
    end

    def http_client
      @http_client ||= Faraday.new(url: ENV['CLERK_URL'], headers: {'Content-Type' => 'application/json'})
    end
  end
end