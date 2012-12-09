require 'rvm2'
require 'rvm2/environment'

require 'ostruct'

class Rvm2::Cli
  def initialize argf, argv
    parameters.argf = argf
    parameters.argv = argv
    # TODO: move initialize somewhere ...
    Rvm2::Settings.instance
    Rvm2::Plugins.instance
  end

  def parameters
    @parameters ||= OpenStruct.new( verbose: false, debug: false )
  end

  def run
    # TODO: parse more flags!?
    detect_flag :debug
    detect_flag :verbose

    if parameters.argv.empty?
      $stderr.puts "No action given!"
      show_help
      return 1
    elsif parameters.argv[0] == "help"
      parameters.argv.shift
      show_help parameters.argv
      return 0
    end

    name, plugin, matched_args = Rvm2::Plugins.instance.first_plugin( :cli, :match_command, parameters.argv )
    command, help = matched_args
    if plugin
      log_debug "Action: #{command*" "}"
      plugin.new.execute command, parameters.argv
      return 0
    else
      $stderr.puts "Unknown action: #{parameters.argv[0]}!"
      show_help
      return 1
    end
  end

  def detect_flag variable, flag=nil
    variable = variable.to_s
    flag ||= "--#{variable}"
    # TODO: detect -- before --flag
    value = !!parameters.argv.delete(flag)
    parameters.send "#{variable}=", value
    log_debug "#{variable.upcase}: #{onoff(value)}"
  end

  def onoff _check, _on="On", _off="Off"
    _check ? _on : _off
  end

  def show_help_arr commands
    commands = commands.map{|command, help| [command.join(" "), help] }
    longest = commands.map{|command, help| command.size }.max
    format = "rvm2 %-#{longest}s - %s"
    commands.each{|command, help|
      $stderr.puts( format % [command, help] )
    }
  end

  def show_help_all
    commands = Rvm2::Plugins.instance.all_by_type :cli
    commands = commands.map{|name, plugin| plugin.commands }
    case commands.size
    when 0 then commands = {"" => "no commands found!" }
    when 1 then commands = commands[0]
    else        commands = commands.inject(&:merge)
    end
    show_help_arr commands
  end

  def show_help args=nil
    if args.nil?
      show_help_all
      return
    end
    name, plugin, matched_args = Rvm2::Plugins.instance.first_plugin( :cli, :match_command, args )
    if plugin
      show_help_arr [ matched_args ] # [ [ command, help ] ]
    else
      show_help_all
    end
  end

  def log_debug message
    $stderr.puts "# #{message}" if parameters.debug
  end
end
