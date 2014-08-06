module Localizer
  class LocalesService
    def self.configuration
      @@configuration ||= YAML.load_file('config/languages.yml')
    end

    def self.current
      Locale.new(I18n.locale)
    end

    def initialize(oem = nil)
      @oem = oem || 'default'
      @locales = LocalesService.configuration[@oem].map { |identifier| Locale.new(identifier) }
    end

    def fallbacks_hash
      all.inject({}) do |memo, locale|
        memo[locale.to_sym] = locale.fallbacks.map(&:to_sym)
        memo
      end
    end

    def available_locales_array
      all.map(&:to_sym)
    end

    def all
      (@locales + languages)
    end

    def languages
      @locales.uniq { |locale| locale.language }.map { |locale| Locale.new(locale.language) }
    end

    def countries
      @locales.map { |locale| locale.country }.uniq
    end

    def locales
      @locales.sort_by { |locale| [I18n.transliterate(locale.localized_country).upcase, I18n.transliterate(locale.localized_language).upcase] }
    end

    def by_country(country)
      locales.select { |locale| locale.country == country }
    end

    def symbols_by_country_and_language(country, language)
      @locales.select do |locale|
        ((country.nil? ? true : locale.country == country)) && locale.language == language
      end.map(&:to_sym)
    end
  end
end
