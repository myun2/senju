require 'yaml'
class Senju::Track
  PATH = Dir.home + '/.senju/tracks'

  def self.load
    if File.exist? PATH
      @data = YAML.load_file(PATH)
    else
      @data = {}
    end
  end

  def self.save
    YAML.dump(@data, File.open(PATH, 'w'))
  end

  def self.all
    self.load
  end

  def self.add(project, issue_no)
    load
    @data[project] = {} unless @data[project]
    @data[project][issue_no.to_i] = nil
    save
  end
end
