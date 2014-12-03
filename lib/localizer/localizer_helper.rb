module Localizer
  module LocalizerHelper
    def sorted_languages(with_country = false)
      locales_service.locales.sort_by do |locale|
        language_sort_token(locale, with_country)
      end
    end

    def link_to_locale(locale, with_country = false)
      link_to locale_name(locale, with_country), url_for(country: locale.country, language: locale.language)
    end

    def locale_name(locale, with_country = false)
      if with_country
        "#{locale.localized_country(scope_prefix: nil)} - #{locale.localized_language(scope_prefix: nil)}"
      else
        "#{locale.localized_language(scope_prefix: nil)}"
      end
    end

    private
    def language_sort_token(locale, with_country)
      if with_country
        locale.localized_country(scope_prefix: nil)
      else
        locale.localized_language(scope_prefix: nil)
      end
    end
  end
end