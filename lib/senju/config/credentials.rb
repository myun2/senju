require 'yaml'
class Senju::Config::Credentials
  def initialize(filepath = nil)
    filepath ||= Dir.home + '/.senju/credentials'
    @data = YAML.load_file(filepath)
  end

  def [](conf)
    @data[conf]
  end
end
