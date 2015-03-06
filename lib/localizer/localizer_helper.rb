module Localizer
  module LocalizerHelper
    def sorted_languages_by_country(oem, current_country, with_country = false)
      Localizer::LocalesService.new(oem).by_country(current_country).sort_by { |locale| locale.sort_key(with_country) }
    end

    def sorted_languages(oem, with_country = false)
      Localizer::LocalesService.new(oem).locales.sort_by { |locale| locale.sort_key(with_country) }
    end


    def link_to_locale(locale, with_country = false)
      link_to locale.name_to_display(with_country), url_for(country: locale.country, language: locale.language)
    end

    def collection_for_locale_select(oem, with_country = false)
      sorted_languages(oem, with_country).map { |locale| [locale.name_to_display(with_country), locale.to_s] }
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
