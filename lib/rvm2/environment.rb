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
    name, shell, hit = Rvm2::Plugins.instance.first_plugin :environment, :supported_shell, :bash

    @shell = shell.new

    if block_given?
      instance_eval &block
    else
      @shell
    end
  end

  # Handle blocks to Rvm2::Environment.shell
  def self.method_missing name, *options
    @shell.send(name, *options)
  end
end
