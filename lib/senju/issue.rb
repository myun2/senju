class Senju::Issue
  attr_reader :raw, :type
  def initialize(raw, type)
    @raw = raw
    @type = type
  end

  def method_missing(method, *args, &block)
    case type
    when "github" then @raw[method]
    when "gitlab", "trello" then @raw.send(method)
    end
  end

  def labels
    case type
    when "github" then super.map(&:name)
    else
      super
    end
  end

  def title
    case type
    when "trello" then name
    else
      super
    end
  end

  def no
    case type
    when "github" then @raw["number"]
    when "gitlab" then @raw.iid
    when "trello" then @raw.short_id
    end
  end

  def owner
    case type
    when "github" then @raw["user"]["login"]
    when "gitlab" then @raw.author.username
    end
  end

  def url
    case type
    when "github" then @raw["html_url"]
    when "gitlab" then @raw.web_url
    end
  end

  def body
    case type
    when "github" then super
    when "gitlab" then @raw.description
    end
  end
end
