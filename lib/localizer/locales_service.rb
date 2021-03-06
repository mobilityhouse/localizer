module Localizer
  class LocalesService
    
    class << self
      attr_accessor :configuration_path
    end
    
    def self.configuration
      path = LocalesService.configuration_path || 'config/languages.yml'
      @@configuration ||= YAML.load_file(path).with_indifferent_access
    end

    def self.current
      Locale.new I18n.locale
    end

    def initialize(oem = 'default')
      @oem = LocalesService.configuration.keys.include?(oem) ? oem : 'default'
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
      Hash[all_locales.map {|locale| [locale.to_sym, locale.fallbacks.map(&:to_sym)] }].tap do |h|
        h.default = []
      end
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

    def locales_with_countries
      @locales_with_countries ||= locales_for_oem if oem_exists?
    end

    private

    def locales_for_oem
      LocalesService.configuration[@oem][:locales].map { |locale_name| Locale.new(locale_name) }
    end

    def oem_exists?
      LocalesService.configuration.has_key? @oem
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
