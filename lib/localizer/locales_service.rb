module Localizer
  class LocalesService
    def self.configuration
      @@configuration ||= YAML.load_file('config/languages.yml').with_indifferent_access
    end

    def self.current
      Locale.new I18n.locale
    end

    def initialize(oem)
      @oem = oem || 'default'
    end

    def available_locales
      all_locales.map &:to_sym
    end

    def languages
      locales_with_countries.uniq(&:language).map { |locale| Locale.new(locale.language) }
    end

    def countries
      locales_with_countries.map(&:country).uniq.sort
    end

    def locales
      locales_with_countries.sort_by do |locale|
        [I18n.transliterate(locale.localized_country).upcase, I18n.transliterate(locale.localized_language).upcase]
      end
    end

    def by_country(country)
      locales.select { |locale| locale.country == country }
    end

    def locales_by(conditions)
      locales = by_country conditions[:country]
      find_specific_language_if_exists(locales, conditions[:language])
    end

    def locale_symbols_by(condition)
      locales_by(condition).map(&:to_sym)
    end

    def fallbacks_hash
      Hash[all_locales.map {|locale| [locale.to_sym, locale.fallbacks.map(&:to_sym)] }]
    end

    def country_fallbacks
      LocalesService.configuration[@oem][:country_fallbacks]
    end

    def language_fallbacks
      LocalesService.configuration[@oem][:language_fallbacks]
    end

    def languages_for_country(country)
      by_country(country).map{ |locale| locale.localized_language(scope_prefix: nil) }
    end

    private

    def locales_with_countries
      @locales_with_countries ||= LocalesService.configuration[@oem][:locales].map { |locale_name| Locale.new(locale_name) }
    end

    def all_locales
      locales_with_countries + languages
    end

    def find_specific_language_if_exists(locales, language)
      selected_locales = locales.select { |locale| locale.language == language}
      selected_locales.empty? ? locales : selected_locales
    end
  end
end
