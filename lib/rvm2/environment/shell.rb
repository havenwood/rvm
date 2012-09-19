class Rvm2::Environment::Shell
  def shell_function
    return <<-EOF
rvm2()
{
  source <( "#{Rvm2.settings.ruby_path}/bin/ruby" "#{Rvm2.settings.rvm_path}/bin/rvm2" "$@" ) || return $?
}
    EOF
  end

  def echo *messages
    [ messages ].flatten.map{ |message|
      "echo #{message.quoted}"
    }
  end

  def eport_array name, value
    "export -a #{name}; #{name}=( #{value.map(&:quoted).join(' ')} )"
  end

  def export_integer name, value
    "export #{name}; #{name}=#{value}"
  end

  def export_string name, value
    "export #{name}; #{name}=#{value.quoted}"
  end

  def export_variable name, value
    case value
    when Array
      eport_array name, value
    when Integer
      export_integer name, value
    else
      export_string name, value
    end
  end

  def PATH path=nil
    if path.nil?
      ENV['PATH'].split(/:/)
    else
      export_variable 'PATH', path.join(':')
    end
  end

  def status value=0
    "return #{value}"
  end
end
