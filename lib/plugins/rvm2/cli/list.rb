require 'rvm2/cli/plugin'
require 'rvm2/environment'
require 'rvm2/use'

class Rvm2::Cli::List < Rvm2::Cli::Plugin
  def self.commands
    { %w{ list } => "list all installed rubies" }
  end

  def execute_list args
    list = Rvm2::List.advenced(true)
    has_aliases = ! list.map(&:alias).reject(&:nil?).empty?

    list.unshift( OpenStruct.new( :name => "# Name", :path => "# Path" , :alias => "# Aliased to" ) )

    longest_name = list.map(&:name).map(&:length).max
    longest_path = list.map(&:path).map(&:length).max

    format_string = "%-#{longest_name}s => %-#{longest_path}s"
    format_string += " %s" if has_aliases

    Rvm2::Environment.shell.echo( list.map{ |ruby|
      format_string % [ ruby.name, ruby.path, ruby.alias ]
    } )
  end
end
