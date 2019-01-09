require "senju/print"
require "senju/track"
require "senju/tasks"

class Senju::Command
  def self.init
      Dir.mkdir Dir.home + "/.senju"
      puts "Create ~/.senju directory".colorize(:green)
  end

  def self.add(name)
    Senju::Projects.add_interactive(args.first)
  end

  def self.track(name, issue_no)
    Senju::Track.add(name, issue_no)
    print "Track issue successfly.\n".colorize(:green)
  end

  def self.start(name, issue_no)
    Senju::Track.status(name, issue_no, "doing")
  end

  def self.done(name, issue_no)
    Senju::Track.erase(args.first, args[1])
    print "Done issue #{args.first} #{args[1]}.\n".colorize(:green)
  end

  def self.task(title)
    Senju::Tasks.add(title)
  end

  def self.exec(command, args)
    args ||= []

    case command
    when "init"       then init
    when "add"        then add(args.first)
    when "track", "t" then track(args.first, args[1].to_i)
    when "start"      then start(args.first, args[1].to_i)
    when "done"       then done(args.first, args[1].to_i)
    when "task"       then task(args.join(" "))

    when "tasks"
      Senju::Tasks.all.each_with_index do |task, i|
        puts "##{i+1} ".colorize(:blue).bold + task
      end

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
