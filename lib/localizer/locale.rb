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

    def fallbacks
      fallbacks = []
      fallbacks << self.class.new(@name) if @country
      fallbacks << self.class.new(@language)
      fallbacks
    end

    def localized_country(options = {})
      I18n.with_locale(self.to_sym) { I18n.t(self.country, options.merge(scope: :countries)) }
    end

    def localized_language(options = {})
      I18n.with_locale(self.to_sym) { I18n.t(self.language, options.merge(scope: :languages)) }
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

    def name_to_display(with_country = false)
      if with_country
        "#{localized_country(scope_prefix: nil)} - #{localized_language(scope_prefix: nil)}"
      else
        localized_language(scope_prefix: nil)
      end
    end

    def sort_key(with_country)
      with_country ? localized_country(scope_prefix: nil) : localized_language(scope_prefix: nil)
    end
  end
end
