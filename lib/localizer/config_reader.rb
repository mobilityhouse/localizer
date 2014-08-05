module Localizer
  class ConfigReader
    cattr_accessor :config_path

    def default_locale
      config_hash[:default].first
    end

    def countries
      config_hash[:countries]
    end

    private

    def config_hash
      @config_hash ||= load_config_from_file
    end

    def load_config_from_file
      YAML.load(File.read(config_path)).with_indifferent_access
    end
  end
end
