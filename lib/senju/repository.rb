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
    @name = name
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

  def issues
    client.issues(name)
  end
end
