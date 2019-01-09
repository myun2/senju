require 'yaml'
class Senju::Projects
  PATH = Dir.home + '/.senju/projects'

  def self.load
    if File.exist? PATH
      @data = YAML.load_file(PATH)
    else
      @data = {}
    end
  end

  def self.write
    YAML.dump(@data, File.open(PATH, 'w'))
  end

  def self.data
    self.load
  end

  def self.[](name)
    data[name] || raise("Unknown project \"#{name}\".")
  end

  def self.[]=(name, table)
    data[name] = table
  end

  def self.add_interactive(name)
    print "Repository type [github, gitlab, trello]: "

    type = STDIN.gets.chomp
    case type
    when "github", "gitlab"
      print "Repository path (team/repository): "
      repo = STDIN.gets.chomp
    when "trello"
      print "board id (like aBcDeF1234): "
      repo = STDIN.gets.chomp
    end

    self[name] = { "repo" => repo, "type" => type }
    write

    print "Senju project add successfly.\n".colorize(:green)
  end
end
