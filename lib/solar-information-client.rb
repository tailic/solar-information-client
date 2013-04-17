require 'yajl'
require 'active_model'
require 'typhoeus'

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'solar-information-client/version.rb'
require 'solar-information-client/config.rb'
require 'solar-information-client/solar_position.rb'
require 'solar-information-client/solar_day.rb'