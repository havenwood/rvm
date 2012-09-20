# could be already initialized in bin/rvm2
unless Kernel.const_defined? :RVM2_LIB_PATH
  RVM2_LIB_PATH = File.expand_path( "..", __FILE__ )
  $:.include?(RVM2_LIB_PATH) || $:.unshift(RVM2_LIB_PATH)
end

class Rvm2; end

require 'rvm2/settings'
require 'rvm2/plugins'

class Rvm2
end
