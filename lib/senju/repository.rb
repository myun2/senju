class Senju::Repository
  attr_reader :name, :options, :type

  def self.all
    Senju::Projects.data.map do |repository, config|
      new(repository, config)
    end
  end

  def self.first
    all.first
  end

  def self.find(name)
    new(name, Senju::Projects[name])
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
    when "trello" then Senju::Trello.new(credential)
    end
  end

  def issues
    if type == "github"
      client.issues(name, labels: options["label"], assignee: options["assignee"]).map do |raw|
        Senju::Issue.new(raw, type)
      end
    else
      client.issues(name).map do |raw|
        Senju::Issue.new(raw, type)
      end
    end
  end

  def issue(no)
    Senju::Issue.new(client.issue(name, no), type)
  end

  def pull_request(no)
    case type
    when "github" then list = Senju::Issue.new(client.pull_request(name, no), type)
    when "gitlab" then list = Senju::Issue.new(client.merge_request(name, no), type)
    end
  end

  def comments(no)
    case type
    when "github" then list = client.issue_comments(name, no)
    when "gitlab" then list = client.issue_notes(name, no)
    end

    list.map do |raw|
      Senju::Comment.new(raw, type)
    end
  end

  def changes(no)
    case type
    when "github" then list = client.pull_request_files(name, no)
    when "gitlab" then list = client.merge_request_changes(name, no).changes
    end

    list.map do |raw|
      Senju::Change.new(raw, type)
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
