class String
  unless self.method_defined? :quoted
    def quoted _start='"', _end=nil
      _end ||= _start
      "#{_start}#{self.to_s}#{_end}"
    end
  end
end

class Rvm2::Environment
  def self.shell &block
    # TODO: add more shells (fish?)
    # TODO: abstract away PATH setting
    # TODO: detect shell via parent pid
    @shell ||= begin
      require 'rvm2/environment/shell'
      Rvm2::Environment::Shell.new
    end

    if block_given?
      Rvm2::Environment.new(@shell).run &block
    else
      @shell
    end
  end

  # Handle blocks to Rvm2::Environment.shell
  def initialize(shell)
    @shell = shell
  end
  def run &block
    @result = []
    instance_eval &block
    @result
  end
  def method_missing name, *options
    @result.push @shell.send(name, *options)
  end
end
