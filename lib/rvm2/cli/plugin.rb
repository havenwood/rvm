require 'rvm2/cli'

class Rvm2::Cli::Plugin
  def self.match_command args
    commands.detect{ |command, help|
      args.slice(0, command.size) == command
    }
  end

  def execute matched, args
    matched.unshift('execute')
    args.shift matched.size-1
    send matched.join("_").to_sym, args
  end
end
