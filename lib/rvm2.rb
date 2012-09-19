class Rvm2
end

require 'rvm2/settings'
require 'rvm2/environment'
require 'rvm2/list'

class Rvm2
  attr_accessor :argf, :argv, :action, :debug, :verbose, :shell

  def initialize argf, argv
    Thread.current[:rvm2] = self
    self.argf = argf
    self.argv = argv
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

  def run
    parse_args
    run_command
  end

  def onoff _check, _on="On", _off="Off"
    _check ? _on : _off
  end

  def detect_flags *flags
    flags.each{|flag| detect_flag flag}
  end

  def detect_flag variable, flag=nil
    variable = variable.to_s
    flag ||= "--#{variable}"
    # TODO: detect -- before --flag
    value = !!argv.delete(flag)
    eval "@#{variable}=value"
    log_debug "#{variable.upcase}: #{onoff(value)}"
  end

  def parse_args
    detect_flags :debug, :verbose, :shell
    # TODO: parse more flags!
    self.action = argv.shift
    log_debug "Action: #{action || "'' -> not given"}"
  end

  def run_command
    case self.action
    when 'show_function'
      puts Rvm2::Environment.shell.shell_function
    when 'reload'
      puts Rvm2::Environment.shell.shell_function
      puts 'RVM reloaded' if verbose
    when 'list'
      puts Rvm2::List.pretty
    when 'current'
      puts Rvm2::List.current
    when 'use'
      puts Rvm2::List.use(*argv)
    else
      $stderr.puts "Unknown action: #{self.action}"
      puts Rvm2::Environment.shell.status 1
      # TODO: show some help
    end
  end

  def log_debug message
    $stderr.puts "# #{message}" if @debug
  end
end
