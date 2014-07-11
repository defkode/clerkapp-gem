require "clerkapp/version"
require "clerkapp/fileless"
require "json"
require "faraday"

class Clerkapp
  class NoAccount < StandardError; end
  class ApiError < StandardError; end

  class << self
    def list(options = {})
      new.list
    end

    def print(form_identifier, fields = {}, options = {})
      raise ArgumentError.new("form_identifier is required") unless form_identifier
      raise ArgumentError.new("fields must be a hash")  unless fields.is_a?(Hash)
      raise ArgumentError.new("options must be a hash") unless options.is_a?(Hash)
      default_options = {
        "test"           => false,
        "async"          => false,
        "raise_on_error" => true
      }
      new.print(form_identifier.to_s, fields, default_options.merge(options))
    end
  end

  def initialize
    raise NoAccount, "CLERK_URL is not specified, did you install heroku add-on?" unless ENV['CLERK_URL']
  end

  def print(form_identifier, fields = {}, options = {})
    options = options.select {|k, v| [:test, :async].include?(k)}
    raise_on_error = options.delete("raise_on_error")
    response = http_client.post "/api/printouts", {
      form_identifier: form_identifier,
      fields:          fields
    }.merge(options).to_json

    if raise_on_error && !response.success?
      raise Clerkapp::ApiError.new("status_code: #{response.status}#{"\n#{response.body}" if response.body.present?}")
    end

    if !response.success?
      parsed(response)
    elsif options["async"]
      parsed(response)['ticket_id']
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
