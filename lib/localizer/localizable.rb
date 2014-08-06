module Localizer
  module Localizable
    extend ActiveSupport::Concern

    included do
      before_filter :configure_i18n_locales, :set_language_and_country
    end

    def configure_i18n_locales
      locales_service = Localizer::LocalesService.new(params[:oem])

      I18n.available_locales = locales_service.available_locales_array
      I18n.fallbacks = locales_service.fallbacks_hash
      I18n.locale = params[:locale] || locales_service.symbols_by_country_and_language(params[:country], params[:language]).first || I18n.default_locale

    rescue I18n::InvalidLocale
      I18n.locale = I18n.default_locale
    end

    def default_url_options
      { locale: I18n.locale }.merge(super)
    end

    def set_language_and_country
      params[:language] = Localizer::LocalesService.current.language
      params[:country] = Localizer::LocalesService.current.country
    end
  end
end
