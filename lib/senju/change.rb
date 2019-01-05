class Senju::Change
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

  def filename
    case type
    when "github" then super
    when "gitlab" then @raw["new_path"]
    end
  end

  def patch
    case type
    when "github" then super
    when "gitlab" then @raw["diff"]
    end
  end
end
