class MockRackApp
  attr_reader :request_body

  def initialize
    @request_headers = {}
  end

  def call(env)
    @env = env
    @request_body = env["rack.input"].read
    [200, { "Content-Type" => "text/plain" }, ["OK"]]
  end

  def [](key)
    @env[key]
  end
end
