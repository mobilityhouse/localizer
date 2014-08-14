require 'active_support/all'
require 'yaml'

Dir["#{File.dirname(__FILE__)}/localizer/**/*.rb"].each { |file| require file }

module Localizer
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset_configuration
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

