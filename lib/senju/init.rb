module Senju
  def self.init
    Dir.mkdir Dir.home + "/.senju"
    puts "Create ~/.senju directory".colorize(:green)
  end
end
