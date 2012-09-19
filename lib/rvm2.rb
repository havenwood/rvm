class Rvm2
end

require 'ostruct'
require 'rvm2/settings'
require 'rvm2/environment'
require 'rvm2/list'

class Rvm2
  def initialize argf, argv
    Thread.current[:rvm2] = self
    parameters.argf = argf
    parameters.argv = argv
  end

  def self.running
    Thread.current[:rvm2]
  end

  def settings
    @settings ||= Rvm2::Settings.new
  end

  def self.settings
    running.settings
  end

  def parameters
    @parameters ||= OpenStruct.new( verbose: false, debug: false )
  end

  def self.parameters
    running.parameters
  end

  def run
    parse_args
    run_command
  end

  def onoff _check, _on="On", _off="Off"
    _check ? _on : _off
  end

  def detect_flag variable, flag=nil
    variable = variable.to_s
    flag ||= "--#{variable}"
    # TODO: detect -- before --flag
    value = !!parameters.argv.delete(flag)
    parameters.send "#{variable}=", value
    log_debug "#{variable.upcase}: #{onoff(value)}"
  end

  def parse_args
    detect_flag :debug
    detect_flag :verbose
    # TODO: parse more flags!
    parameters.action = parameters.argv.shift
    log_debug "Action: #{parameters.action || "'' -> not given"}"
  end

  def run_command
    case parameters.action
    when 'show_function'
      puts Rvm2::Environment.shell.shell_function
    when 'reload'
      puts Rvm2::Environment.shell.shell_function
      puts Rvm2::Environment.shell.echo 'RVM reloaded' if parameters.verbose
    when 'list'
      puts Rvm2::List.pretty
    when 'current'
      puts Rvm2::List.current
    when 'use'
      puts Rvm2::List.use(*parameters.argv)
    else
      $stderr.puts "Unknown action: #{parameters.action}"
      puts Rvm2::Environment.shell.status 1
      # TODO: show some help
    end
  end

  def log_debug message
    $stderr.puts "# #{message}" if parameters.debug
  end
end
