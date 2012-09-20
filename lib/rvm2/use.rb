require 'rvm2/list'

class Rvm2::Use
  attr_reader :name, :options

  def initialize name, *options
    @name = name
    @options = options
  end

  def environment
    _new_ruby, _new_gem_home, _new_gem_path = detect_ruby
    return nil if _new_ruby.nil?
    _path = Rvm2::Environment.shell.PATH
    _gem_path = ENV['GEM_PATH'].split(/:/)
    _path = clean_path _path, ENV['GEM_HOME'], _gem_path, ENV['MY_RUBY_HOME']
    _path = [ _new_gem_path, _new_ruby ].flatten.map{|p| File.join(p,'bin') } + _path
    return _path, _new_gem_home, _new_gem_path.join(":"), _new_ruby
  end

private

  def clean_path _path, _gem_home, _gem_path, _old_ruby
    [
      _gem_home, _gem_path, _old_ruby
    ].flatten.sort.uniq.map{ |path|
      File.join( path, 'bin' )
    }.each{ |path|
      _path.reject!{ |element| element == path }
    }
    _path
  end

  def detect_ruby
    name, plugin, matched_args = Rvm2::Plugins.instance.first_plugin( :selector, :name?, Rvm2::Settings.instance.selector || "any" )
    if plugin
      log_debug "Selector: #{command*" "}"
      plugin.new(name, *options).detect_ruby
      return 0
    else
      raise "Missing selector for: #{Rvm2::Settings.instance.selector}"
    end
  end
end
