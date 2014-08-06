module Localizer
  class Locale
    include Comparable
    attr_reader :name, :language, :country

    def initialize(identifier)
      @name = identifier.to_s
      @language, @country = @name.split('-')
    end

    def language_only?
      @country.nil?
    end

    def parent
      self.class.new @language
    end

    def fallbacks
      [parent]
    end

    def localized_country
      I18n.with_locale(self.to_sym) { I18n.t(self.country, scope: :countries) }
    end

    def localized_language
      I18n.with_locale(self.to_sym) { I18n.t(self.language, scope: :languages) }
    end

    def <=>(other)
      self.name <=> other.name
    end

    def to_s
      name
    end

    def to_sym
      name.to_sym
    end
  end
end
