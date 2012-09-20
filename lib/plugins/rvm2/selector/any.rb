require 'rvm2/list'

class Rvm2::Selector; end

class Rvm2::Selector::Any
  attr_reader :name, :options

  def self.name? name
    name == 'any'
  end

  def initialize name, *options
    @name = name
    @options = options
  end

  def detect_ruby
    name, gemset = self.name.split(/@/)
    name_regex = Regexp.new(name)
    _ruby_path = Rvm2::List.paths(true).detect{ |path| File.basename(path) =~ name_regex }
    return nil if _ruby_path.nil?
    return nil unless Dir.exist?(_ruby_path)
    _gem_home = _ruby_path.sub(/\/rubies\//, "/gems/")
    _gem_path = [ "#{_gem_home}@global" ]
    _gem_home = "#{_gem_home}@#{gemset}" if gemset
    _gem_path.unshift _gem_home
    [ _ruby_path, _gem_home, _gem_path ]
  end
end
