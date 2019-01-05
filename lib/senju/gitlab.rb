require 'gitlab'
class Senju::Gitlab
  attr_reader :client

  def initialize(access_token_or_hash)
    if access_token_or_hash.is_a? Hash
      options = access_token_or_hash
      endpoint ||= "https://#{options["host"]}/api/v4"
      @client = Gitlab.client(endpoint: endpoint, private_token: options["token"])
    else
      endpoint ||= "https://gitlab.com/api/v4"
      @client = Gitlab.client(endpoint: endpoint, private_token: access_token)
    end
  end

  def method_missing(method, *args, &block)
    client.send(method, *args, &block)
  end
end
