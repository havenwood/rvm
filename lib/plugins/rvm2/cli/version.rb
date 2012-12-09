require 'rvm2/cli/plugin'

class Rvm2::Cli::Version < Rvm2::Cli::Plugin
  def self.commands
    { %w{ version } => "show program version" }
  end

  def execute_version args
    puts "0.1.0"
  end
end
