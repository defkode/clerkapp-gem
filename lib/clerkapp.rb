require "clerkapp/version"
require "clerkapp/fileless"
require "json"
require "faraday"

class Clerkapp
  class NoAccount < StandardError; end
  class ApiError < StandardError; end

  class << self
    def list(options = {})
      client = new(options)
      client.list
    end

    def print(print_options, options = {})
      client = new(options)
      client.print(print_options)
    end
  end

  def initialize(options)
    raise NoAccount, "CLERK_URL is not specified, please install addon" unless ENV['CLERK_URL']
    raise ArgumentError.new("please pass in an options hash") unless options.is_a?(Hash)

    default_options = {
      "test"           => false,
      "async"          => false,
      "raise_on_error" => true
    }

    @options = default_options.merge(options)
  end

  def print(options)
    options = @options.merge(options)
    raise ArgumentError.new("please pass in an options hash") unless options.is_a?(Hash)
    raise_on_error = options.delete("raise_on_error")
    response = http_client.post "/api/printouts", options.to_json

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
      Fileless.new(response.body, options["name"], 'application/pdf')
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
