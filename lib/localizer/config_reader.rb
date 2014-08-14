module Localizer
  class Configuration
    attr_accessor :except_actions, :country_not_supported_url

    def initialize
      @except_actions = []
      @country_not_supported_url = nil
    end
  end
end
