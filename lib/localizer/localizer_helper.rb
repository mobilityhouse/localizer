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
  end
end
