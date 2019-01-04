require 'gitlab'
class Senju::Gitlab
  attr_reader :client

  def initialize(access_token, endpoint = nil)
    endpoint ||= "https://gitlab.com/api/v4"
    @client = Gitlab.client(endpoint: endpoint, private_token: access_token)
  end

  def method_missing(method, *args, &block)
    client.send(method, *args, &block)
  end
end
