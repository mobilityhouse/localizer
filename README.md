localizer [![Code Climate](https://codeclimate.com/github/mobilityhouse/localizer/badges/gpa.svg)](https://codeclimate.com/github/mobilityhouse/localizer)
=========

## Installation

Add this line to your application's Gemfile:

    gem 'localizer', git: 'git@github.com:mobilityhouse/localizer.git'

And then execute:

    $ bundle


## Getting started

#### Prepare languages file
First you need to create a file (languages.yml) with your all locales and put it to the config dir.
    
    # languages.yml
    
    default:
      locales:
        - en-GB
      language_fallbacks:
        de: DE
        fr: FR        
      country_fallbacks:
        CH: de
        FR: fr        
    first_subject:
      locales: 
        - en-GB
      language_fallbacks:
        de: DE
        fr: FR        
      country_fallbacks:
        CH: de
        FR: fr        

#### Create initializer file

    Localizer.configure do |config|
      config.except_actions = [:country_not_supported, :country_not_supported_legal_notice]
      config.country_not_supported_url = "/pages/country_not_supported"
    end

#### Add localizer to your ApplicationController

Add this lines to application_controller.rb:

    class ApplicationController < ActionController::Base
      include Localizer::Localizable
      
      # ...
    end
    
Localizer setups 3 things for I18n:
- I18n.available_locales
- I18n.fallbacks
- I18n.locale

Value of I18n.locale depends on:
- Params `country` and `language`
- Param `country` if `language` is missing (taken from from `country_fallbacks`)
- Param `language` if `country` is missing (taken from `language_fallbacks`)

If we can't detect country or country is not supported user will be redirected to `config.country_not_supported_url`

## Contributing

1. Fork it ( https://github.com/mobilityhouse/localizer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
