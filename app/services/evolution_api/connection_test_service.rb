class EvolutionApi::ConnectionTestService < EvolutionApi::BaseService
  def test
    response = http_client.get(
      api_url('/instance/fetchInstances'),
      headers: request_headers,
      timeout: 10
    )

    handle_response(response)

    {
      success: true,
      message: 'Connection successful',
      instances: response.parsed_response
    }
  rescue StandardError => e
    {
      success: false,
      message: e.message
    }
  end
end
