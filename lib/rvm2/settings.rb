require 'ostruct'
require 'singleton'

class Rvm2::Settings < OpenStruct
  include Singleton

  def initialize(hash = {})
    super(hash)
    setup
    # TODO: read settings from ~/.rvm2.yaml
  end

  def setup
    # TODO: improve autodetection
    self.ruby_path    ||= File.join( ENV['HOME'], ".rvm/rubies/ruby-1.9.3-p194" )
    self.rvm_path     ||= File.join( ENV['HOME'], "projects/rvm/rvm2" ) #File.join( ENV['HOME'], ".rvm2" )
    self.rubies_paths ||= []
    [
      File.join( ENV['HOME'], ".rvm/rubies"),
      File.join( self.rvm_path, "rubies" ),
      "/usr/local/rvm/rubies",
    ].each {|dir|
      if Dir.exist?(dir) and not self.rubies_paths.include?( dir )
        self.rubies_paths.push( dir )
      end
    }
  end
end
