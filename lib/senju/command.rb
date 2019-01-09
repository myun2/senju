require "senju/print"
require "senju/track"

class Senju::Command
  def self.init
      Dir.mkdir Dir.home + "/.senju"
      puts "Create ~/.senju directory".colorize(:green)
  end

  def self.exec(command, args)
    args ||= []

    case command
    when "init" then init
    when "add"
      Senju::Projects.add_interactive(args.first)

    when "track", "t"
      Senju::Track.add(args.first, args[1])
      print "Track issue successfly.\n".colorize(:green)

    when "start"
      Senju::Track.status(args.first, args[1], "doing")

    when "done"
      Senju::Track.erase(args.first, args[1])
      print "Done issue #{args.first} #{args[1]}.\n".colorize(:green)

    when "tracks"
      Senju::Track.all.each do |project, issues|
        repo = Senju::Repository.find(project)
        issues.each do |issue, data|
          Senju::Print.exec(repo, issue, "-v")
        end
      end

    else
      if command
        Senju::Print.exec(Senju::Repository.find(command), args.first, args[1])
      else
        Senju::Repository.all.each do |repo|
          Senju::Print.exec(repo)
        end
      end
    end
  end
end

Senju::Command.exec(ARGV[0], ARGV[1..-1])
