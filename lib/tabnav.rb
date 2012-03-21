require 'tabnav/version'

module Tabnav
end

require 'tabnav/tab'
require 'tabnav/navbar'
require 'tabnav/helper'
ActionController::Base.helper Tabnav::Helper
