module Localizer
  module Localizable
    extend ActiveSupport::Concern

    included do
      prepend_before_filter :configure_i18n_locales
      before_filter :set_language_and_country
    end

    def configure_i18n_locales
      I18n.available_locales = locales_service.available_locales
      I18n.fallbacks = locales_service.fallbacks_hash
      set_locale_by_params
    end

    def set_language_and_country
      params[:language] = current_locale.language
      params[:country] = current_locale.country
    end

    def default_url_options
      super.merge locale: I18n.locale
    end

    private

    def locales_service
      @locales_service ||= LocalesService.new params[:oem]
    end

    def current_locale
      LocalesService.current
    end

    def set_locale_by_params
      begin
        I18n.locale = params[:locale] || locales_service.locale_symbols_by(params).first
      rescue I18n::InvalidLocale
        I18n.locale = I18n.default_locale
      end
    end
  end
end
