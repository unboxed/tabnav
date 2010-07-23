$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'action_controller'
require 'nav_logic'

require 'spec'
require 'spec/autorun'

# The parts of rspec-rails necessary to use helper example groups
class ApplicationController < ActionController::Base
end
require 'active_support/test_case'
require 'spec/test/unit'
require 'spec/rails/example'
require 'spec/rails/interop/testcase'

Spec::Runner.configure do |config|

end
