require 'octokit'
class Senju::Github
  attr_reader :client

  def initialize(access_token)
    @client = Octokit::Client.new(access_token: access_token)
  end

  def method_missing(method, *args, &block)
    client.send(method, args, block)
  end
end
