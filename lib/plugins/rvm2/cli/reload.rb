require 'rvm2/cli/plugin'
require 'rvm2/environment'

class Rvm2::Cli::Reload < Rvm2::Cli::Plugin
  def self.commands
    {
      %w{ reload } => "redefine rvm2 function ... it is enough to define it once!",
      %w{ define function } => "define rvm function",
    }
  end

  def execute_define_function args
    Rvm2::Environment.shell.shell_function
  end

  def execute_reload args
    Rvm2::Environment.shell {
      shell_function
      echo "Rvm reloaded!"
    }
  end
end
