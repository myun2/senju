require 'yaml'
class Senju::Config::Projects
  attr_reader :data
  def initialize(filepath = nil)
    filepath ||= Dir.home + '/.senju/projects'
    @data = YAML.load_file(filepath)
  end

  def [](conf)
    @data[conf]
  end
end

class Senju::Config::Project
  def self.all
    Senju::Config::Projects.new.data
  end
end
