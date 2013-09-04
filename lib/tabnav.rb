require 'action_controller' unless defined?(ActionController)

require 'tabnav/version'
require 'tabnav/tab'
require 'tabnav/navbar'
require 'tabnav/helper'

ActionController::Base.helper Tabnav::Helper
