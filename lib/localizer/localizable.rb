module Localizer
  module Localizable
    extend ActiveSupport::Concern

    included do
      prepend_before_filter :configure_i18n_locales, except: Localizer.configuration.except_actions
      helper_method :current_country, :current_oem, :current_language, :locales_service
    end

    def configure_i18n_locales
      upcase_country_param
      restore_locale_params_from_cookies

      I18n.available_locales = locales_service.available_locales
      I18n.fallbacks         = locales_service.fallbacks_hash

      set_country_by_language if params[:country].nil? && params[:language].present?
      set_language_by_country if params[:country].present? && params[:language].nil?

      check_for_supported_country

      set_locale_by_params
      set_cookies_by_params
    end

    def set_country_by_language
      params[:country] = locales_service.language_fallbacks[params[:language]]
    end

    def set_language_by_country
      params[:language] = locales_service.country_fallbacks[params[:country]]
    end

    def default_url_options
      super.merge language: current_locale.language, country: current_locale.country
    end

    def current_country
      params[:country]
    end

    def current_language
      params[:language]
    end

    def locales_service
      @locales_service ||= LocalesService.new current_oem
    end

    private

    def check_for_supported_country
      redirect_to Localizer.configuration.country_not_supported_url unless supported_country?
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
        params[:country] = current_locale.country
        params[:language] = current_locale.language
      rescue I18n::InvalidLocale
        I18n.locale = I18n.default_locale
      end
    end

    def set_cookies_by_params
      cookies[:country] = { value: params[:country], expires: 1.year.from_now, domain: "#{params[:oem]}.#{ENV['BASE_HOST']}" }
      cookies[:language] = { value: params[:language], expires: 1.year.from_now, domain: "#{params[:oem]}.#{ENV['BASE_HOST']}"}
    end

    def restore_locale_params_from_cookies
      params[:country] ||= cookies[:country]
      params[:language] ||= cookies[:language]
    end

    def upcase_country_param
      params[:country].try :upcase!
    end
  end
end
