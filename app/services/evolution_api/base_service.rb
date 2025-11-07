class EvolutionApi::BaseService
  attr_reader :config

  def initialize(config)
    @config = config
  end

  private

  def http_client
    @http_client ||= HTTParty
  end

  def request_headers
    {
      'Content-Type' => 'application/json',
      'apikey' => config.api_key
    }
  end

  def api_url(path)
    "#{config.formatted_api_url}#{path}"
  end

  def handle_response(response)
    case response.code
    when 200..299
      JSON.parse(response.body) if response.body.present?
    when 401
      raise StandardError, 'Evolution API: Unauthorized - check your API key'
    when 404
      raise StandardError, 'Evolution API: Resource not found'
    else
      raise StandardError, "Evolution API Error: #{response.code} - #{response.body}"
    end
  end
end
