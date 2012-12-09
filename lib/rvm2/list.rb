require 'ostruct'

class Rvm2::List
  def self.paths aliases=false
    _list = Rvm2::Settings.instance.rubies_paths.map{ |dir|
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
  end
end
