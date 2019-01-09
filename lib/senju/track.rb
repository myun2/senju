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

  def self.erase(project, issue_no)
    load
    @data[project].delete(issue_no.to_i)
    save
  end

  def self.add(project, issue_no)
    load
    @data[project] = {} unless @data[project]
    @data[project][issue_no.to_i] = nil
    save
  end

  def self.status(project, issue_no, status)
    load
    @data[project] = {} unless @data[project]
    @data[project][issue_no.to_i] = status
    save
  end
end
