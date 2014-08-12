module Localizer
  module Localizable
    extend ActiveSupport::Concern

    included do
      prepend_before_filter :configure_i18n_locales
      before_filter :set_language_and_country
      before_filter :check_for_supported_country

      helper_method :current_country, :current_oem, :locales_service
    end

    def configure_i18n_locales
      I18n.available_locales = locales_service.available_locales
      I18n.fallbacks         = locales_service.fallbacks_hash
      set_locale_by_params
    end

    def set_language_and_country
      params[:language] = current_locale.language
      params[:country]  = current_locale.country
    end

    def default_url_options
      super.merge language: current_locale.language, country: current_locale.country
    end

    def current_country
      params[:country]
    end

    def current_oem
      params[:oem]
    end

    def locales_service
      @locales_service ||= LocalesService.new current_oem
    end

    private

    def check_for_supported_country
      redirect_to country_not_supported_path unless supported_country?
    end

    def supported_country?
      current_country.in? supported_countries_list
    end

    def supported_countries_list
      locales_service.countries
    end

    def current_locale
      LocalesService.current
    end

    def set_locale_by_params
      begin
        I18n.locale = locales_service.locale_symbols_by(params).first || I18n.default_locale
      rescue I18n::InvalidLocale
        I18n.locale = I18n.default_locale
      end
    end
  end
end
