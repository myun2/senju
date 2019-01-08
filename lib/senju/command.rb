require "ap"
require "colorize"
require "tty-markdown"
require "rumoji"
require "senju/diff"
require "senju/init"

COLORS = %w{green blue light_blue}

def link_to(text, url)
  "\e]8;;#{url}\e\\#{text}\e]8;;\e\\"
end

def print_issue(issue)
  print link_to("##{issue.no} ".colorize(:blue).bold, issue.url) + issue.title
  if issue.labels.length != 0
    issue.labels.each do |label|
      print " [#{label}]".colorize(:light_blue)
    end
  end
  print "\n"
end

def exec(repo, command, option)
  puts "================= #{repo.name} ====================".colorize(:green).bold

  if command.to_i != 0
    issue = repo.issue(command.to_i)
    print_issue issue
    puts "Opened by #{issue.owner} at #{issue.created_at}"

    puts "\n" + Rumoji.decode(TTY::Markdown.parse(issue.body))

    if option == "-v" || option == "comments"
      repo.comments(command.to_i).each do |comment|
        #color = COLORS[comment.owner[0].ord % 3]
        puts "\nComment: #{comment.owner} at #{comment.created_at}".bold
        puts Rumoji.decode(TTY::Markdown.parse(comment.body))
      end
    elsif option == "diff"
      repo.changes(command.to_i).each do |change|
        puts "\n#{change.filename}".bold
        puts Senju::Diff.print(change.patch)
      end
    end

    return
  end

  case command
  when "issues"
    repo.issues.each do |issue|
      print_issue(issue)
    end
  when "mr"
    command = option
    option = ARGV[3]
    issue = repo.pull_request(command.to_i)
    print_issue issue
    puts "Opened by #{issue.owner} at #{issue.created_at}"

    puts "\n" + Rumoji.decode(TTY::Markdown.parse(issue.body))

    if option == "-v" || option == "comments"
      repo.comments(command.to_i).each do |comment|
        #color = COLORS[comment.owner[0].ord % 3]
        puts "\nComment: #{comment.owner} at #{comment.created_at}".bold
        puts Rumoji.decode(TTY::Markdown.parse(comment.body))
      end
    elsif option == "diff"
      repo.changes(command.to_i).each do |change|
        puts "\n#{change.filename}".bold
        puts Senju::Diff.print(change.patch)
      end
    end
  when "pr"
    repo.pull_requests.each do |issue|
      print_issue(issue)
    end
  end
end

repo = ARGV[0]
command = ARGV[1] || "issues"
option = ARGV[2]

if ARGV[0] == "init"
  Senju.init
elsif repo
  exec(Senju::Repository.find(repo), command, option)
else
  Senju::Repository.all.each do |repo|
    exec(repo, command, option)
  end
end
