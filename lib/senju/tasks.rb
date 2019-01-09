require 'yaml'
class Senju::Tasks
  PATH = Dir.home + '/.senju/tasks'

  def self.load
    if File.exist? PATH
      @data = YAML.load_file(PATH)
    else
      @data = []
    end
  end

  def self.save
    YAML.dump(@data, File.open(PATH, 'w'))
  end

  def self.all
    self.load
  end

  def self.add(title)
    load
    @data << title
    save
  end
end
