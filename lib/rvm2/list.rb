require 'ostruct'

class Rvm2::List
  def self.paths aliases=false
    _list = Rvm2.settings.rubies_paths.map{ |dir|
      Dir[ File.join(dir, "*") ]
    }.flatten
    _list.reject!{ |path| File.symlink? path } unless aliases
    _list
  end

  def self.names
    paths.map{ |path| File.basename(path) }.sort.uniq
  end

  def self.advenced aliases=false
    list = ( list || paths(aliases) ).map{ |path|
      [ File.basename(path), path ]
    }.sort.uniq{ |name, path|
      name
    }.map{ |name, path|
      OpenStruct.new( :name => name, :path => path, :alias => File.symlink?(path) ? File.readlink(path) : nil )
    }
  end

  def self.pretty list=nil
    list = advenced(true)
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

  def self.current
    Rvm2::Environment.shell.echo [
      "ruby: #{ENV['MY_RUBY_HOME'] || 'system'}",
      "gems: #{ENV['GEM_PATH'] || 'not in effect'}",
    ]
  end

  def self.clean_path _path, _gem_home, _gem_path, _old_ruby
    [
      _gem_home, _gem_path, _old_ruby
    ].flatten.sort.uniq.map{ |path|
      File.join( path, 'bin' )
    }.each{ |path|
      _path.reject!{ |element| element == path }
    }
    _path
  end

  def self.detect_ruby name, *options
    name, gemset = name.split(/@/)
    name_regex = Regexp.new(name)
    _ruby_path = self.paths(true).detect{ |path| File.basename(path) =~ name_regex }
    return nil if _ruby_path.nil?
    return nil unless Dir.exist?(_ruby_path)
    _gem_home = _ruby_path.sub(/\/rubies\//, "/gems/")
    _gem_path = [ "#{_gem_home}@global" ]
    _gem_home = "#{_gem_home}@#{gemset}" if gemset
    _gem_path.unshift _gem_home
    [ _ruby_path, _gem_home, _gem_path ]
  end

  def self.use name, *options
    _new_ruby, _new_gem_home, _new_gem_path = self.detect_ruby name, *options
    return ([
      Rvm2::Environment.shell.echo("#{name} is not installed."),
      Rvm2::Environment.shell.status(1),
    ]) if _new_ruby.nil?
    _path = Rvm2::Environment.shell.PATH
    _gem_path = ENV['GEM_PATH'].split(/:/)
    _path = self.clean_path _path, ENV['GEM_HOME'], _gem_path, ENV['MY_RUBY_HOME']
    _path = [ _new_gem_path, _new_ruby ].flatten.map{|p| File.join(p,'bin') } + _path
    return Rvm2::Environment.shell do
      echo "Using #{_new_ruby}"
      PATH( _path )
      export_variable( 'GEM_HOME', _new_gem_home )
      export_variable( 'GEM_PATH', _new_gem_path.join(":") )
      export_variable( 'MY_RUBY_HOME', _new_ruby )
    end
  end
end
