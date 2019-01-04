require 'yaml'
class Senju::Credentials
  attr_reader :data
  def initialize(filepath = nil)
    filepath ||= Dir.home + '/.senju/credentials'
    @data = YAML.load_file(filepath)
  end

  def [](conf)
    @data[conf]
  end
end

class Senju::Credential
  def self.all
    Senju::Credentials.new.data
  end

  def self.find(key)
    all[key]
  end
end
