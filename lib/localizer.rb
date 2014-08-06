require 'active_support/all'
require 'yaml'

Dir["#{File.dirname(__FILE__)}/localizer/**/*.rb"].each { |file| require file }
