require 'bundler/setup'
Bundler.require(:default, :development)

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  config.before(:all) do
    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
    Localizer::ConfigReader.config_path = "#{File.dirname(__FILE__)}/example_configs/basic_languages.yml"
  end
end
