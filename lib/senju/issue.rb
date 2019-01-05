class Senju::Issue
  attr_reader :raw, :type
  def initialize(raw, type)
    @raw = raw
    @type = type
  end

  def method_missing(method, *args, &block)
    case type
    when "github" then @raw[method]
    when "gitlab" then @raw.send(method)
    end
  end

  def no
    case type
    when "github" then @raw["number"]
    when "gitlab" then @raw.iid
    end
  end

  def url
    case type
    when "github" then @raw["html_url"]
    when "gitlab" then @raw.web_url
    end
  end
end
