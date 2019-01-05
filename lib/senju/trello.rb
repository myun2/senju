require 'trello'
class Senju::Trello
  attr_reader :client

  def initialize(params)
    @client = Trello::Client.new(
      consumer_key: params["key"],
      consumer_secret: params["secret"],
      oauth_token: params["token"]
    )
  end

  def method_missing(method, *args, &block)
    client.send(method, *args, &block)
  end

  def board(repo)
    client.find(:boards, repo)
  end

  def columns(repo)
    board(repo).lists
  end

  def issues(repo)
    cards = []
    columns(repo).each do |column|
      column.cards.each do |card|
        cards << card
      end
    end
    cards
  end
end
