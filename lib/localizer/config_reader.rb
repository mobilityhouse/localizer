module Localizer
  class Configuration
    attr_accessor :except_actions, :country_not_supported_url, :cookie_domain, :base_host

    def initialize
      @except_actions = []
      @country_not_supported_url = nil
      @cookie_domain = lambda { "#{params[:oem]}.#{base_host}" }
      @base_host = nil
    end
  end
end
