require 'rvm2/cli/plugin'
require 'rvm2/environment'
require 'rvm2/use'

class Rvm2::Cli::Use < Rvm2::Cli::Plugin
  def self.commands
    { %w{ use } => "switch current ruby" }
  end

  def execute_use args
    Rvm2::Environment.shell do
      if args.empty?
        echo "Ruby name must follow 'use'!"
        status 1
        return
      end
      _path, _new_gem_home, _new_gem_path, _new_ruby = Rvm2::Use.new(*args).environment
      if _path
        echo "Using #{_new_ruby}"
        PATH _path
        export_variable 'GEM_HOME', _new_gem_home
        export_variable 'GEM_PATH', _new_gem_path
        export_variable 'MY_RUBY_HOME', _new_ruby
      else
        echo "#{name} is not installed."
        status 1
      end
    end
  end
end
