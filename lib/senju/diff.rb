class Senju::Diff
  def self.print(patch)
    patch.split("\n").map do |line|
      case line
      when /^(---|\+\+\+|\\\\)/
        "\033[90m#{line.chomp}\033[0m"
      when /^\+/
        "\033[32m#{line.chomp}\033[0m"
      when /^-/
        "\033[31m#{line.chomp}\033[0m"
      when /^@@/
        "\033[36m#{line.chomp}\033[0m"
      else
        line.chomp
      end
    end.join("\n") + "\n"
  end
end
