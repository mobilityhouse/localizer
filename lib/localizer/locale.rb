module Localizer
  class Locale
    include Comparable

    attr_reader :name, :language, :country

    def initialize(identifier)
      @name = identifier.to_s
      @country = @name.split('-').last
      @language = @name.split('-').first
    end

    def language_only?
      @name.to_s.split('-').count == 1
    end

    def parent
      self.class.new(@name.split('-').first)
    end

    def fallbacks
      if language_only?
        [ self ]
      else
        [ parent ]
      end
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
      @name
    end

    def to_sym
      to_s.to_sym
    end
  end
end
