require 'yaml'
class Senju::Repos
  attr_reader :data
  def initialize(filepath = nil)
    filepath ||= Dir.home + '/.senju/repos'
    @data = YAML.load_file(filepath)
  end

  def [](conf)
    @data[conf]
  end
end

class Senju::Repository
  attr_reader :name, :options, :type

  def self.all
    Senju::Repos.new.data.map do |repository, config|
      new(repository, config)
    end
  end

  def self.first
    all.first
  end

  def self.find(name)
    new(name, Senju::Repos.new[name])
  end

  def initialize(name, options)
    @name = options["repo"] || name
    @options = options
    @type = options["type"]
  end

  def client
    credential = Senju::Credential.find(type)
    case type
    when "github" then Senju::Github.new(credential)
    when "gitlab" then Senju::Gitlab.new(credential)
    end
  end

  def issue(no)
    Senju::Issue.new(client.issue(name, no), type)
  end

  def issues
    client.issues(name).map do |raw|
      Senju::Issue.new(raw, type)
    end
  end

  def pull_requests
    case type
    when "github" then list = client.pull_requests(name)
    when "gitlab" then list = client.merge_requests(name)
    end

    list.map do |raw|
      Senju::Issue.new(raw, type)
    end
  end
end
