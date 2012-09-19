class String
  unless self.method_defined? :quoted
    def quoted _start='"', _end=nil
      _end ||= _start
      "#{_start}#{self.to_s}#{_end}"
    end
  end
  unless self.method_defined? :echo?
    def echo?
      !! @echo
    end
  end
  unless self.method_defined? :echo!
    def echo!
      @echo = true
    end
  end
  unless self.method_defined? :echo
    def echo
      _str = clone
      _str.instance_variable_set :@echo, true
      _str
    end
  end
end

class Rvm2::Environment
  def self.shell
    # TODO: add more shells (fish?)
    # TODO: detect shell via parent pid
    @shell ||= begin
      require 'rvm2/environment/shell'
      Rvm2::Environment::Shell.new
    end
  end
end
