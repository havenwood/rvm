require 'rvm2/cli/plugin'
require 'rvm2/environment'

class Rvm2::Cli::Current < Rvm2::Cli::Plugin
  def self.commands
    { %w{ current } => "show current used ruby" }
  end

  def execute_current args
    Rvm2::Environment.shell {
      echo "ruby: #{ENV['MY_RUBY_HOME'] || 'system'}"
      echo "gems: #{ENV['GEM_PATH'] || 'not in effect'}"
    }
  end
end
