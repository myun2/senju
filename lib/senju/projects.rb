require 'yaml'
class Senju::Projects
  attr_reader :data
  def initialize(filepath = nil)
    filepath ||= Dir.home + '/.senju/projects'
    @data = YAML.load_file(filepath)
  end

  def [](conf)
    @data[conf]
  end
end
