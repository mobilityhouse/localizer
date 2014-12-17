module Localizer
  module LocalizerHelper
    def sorted_languages_by_country(current_country, with_country = false)
      locales_service.by_country(current_country).sort_by { |locale| locale.sort_key(with_country) }
    end

    def sorted_languages(with_country = false)
      locales_service.locales.sort_by { |locale| locale.sort_key(with_country) }
    end

    def link_to_locale(locale, with_country = false)
      link_to locale.name_to_display(with_country), url_for(country: locale.country, language: locale.language)
    end

    def collection_for_country_select(oem)
      Localizer::LocalesService.new(oem).countries.map do |country|
        [I18n.t("countries.#{country}", scope_prefix: nil), country]
      end
    end

    def collection_for_language_select(oem)
      Localizer::LocalesService.new(oem).languages.map do |language|
        [I18n.t("languages.#{language}", scope_prefix: nil), language]
      end
    end
  end
end
