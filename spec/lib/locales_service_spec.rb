describe Localizer::LocalesService do
  subject { described_class.new('oem') }

  let(:locales_with_countries) do
    {
      'oem' => {
        locales: %w(pl-PL de-DE fr-DE en-US en-GB),
        country_fallbacks: {
          'PL' => :pl,
          'DE' => :de,
          'US' => :en,
          'GB' => :en
        },
        language_fallbacks: {
          pl: 'PL',
          de: 'DE',
          fr: 'DE',
          en: 'GB'
        }
      }
    }.with_indifferent_access
  end

  before do
    allow(described_class).to receive(:configuration).and_return(locales_with_countries)
    I18n.available_locales = subject.available_locales
    I18n.fallbacks = subject.fallbacks_hash
  end

  describe '#fallbacks_hash' do
    let(:fallbacks_hash) {
      {
        :'pl-PL' => [:'pl-PL', :pl],
        :'de-DE' => [:'de-DE', :de],
        :'fr-DE' => [:'fr-DE', :fr],
        :'en-US' => [:'en-US', :en],
        :'en-GB' => [:'en-GB', :en],
        :pl      => [:pl],
        :en      => [:en],
        :de      => [:de],
        :fr      => [:fr]
      }
    }

    it 'returns correctly formatted fallbacks hash' do
      expect(subject.fallbacks_hash).to eq(fallbacks_hash)
    end
  end

  describe '#available_locales' do
    let(:available_locales) {
      [:'pl-PL', :'de-DE', :'fr-DE', :'en-US', :'en-GB', :pl, :de, :fr, :en]
    }

    it 'returns array of available locales' do
      expect(subject.available_locales).to eq(available_locales)
    end
  end

  describe '#languages' do
    let(:languages) do
      %w(pl de fr en).map {|language| Localizer::Locale.new(language)}
    end

    it 'returns list of locales' do
      expect(subject.languages).to eq(languages)
    end
  end

  describe '#by_country' do
    let(:expected_locales) { [Localizer::Locale.new('fr-DE'), Localizer::Locale.new('de-DE')] }

    it 'returns list of locales for given country' do
      expect(subject.by_country('DE')).to match_array(expected_locales)
    end
  end

  describe '#locales_by' do
    context 'when both country and language are given' do
      let(:expected_locales) { [:'de-DE'] }

      it 'returns list of locales' do
        expect(subject.locale_symbols_by(country: 'DE', language: 'de')).to eq(expected_locales)
      end
    end

    context 'when language is nil' do
      let(:expected_locales) { [:'de-DE', :'fr-DE'] }

      it 'returns all locales with matching country' do
        expect(subject.locale_symbols_by(country: 'DE')).to eq(expected_locales)
      end
    end

    context 'when language is unsupported in country' do
      let(:expected_locales) { [:'de-DE', :'fr-DE'] }

      it 'returns all locales with matching country' do
        expect(subject.locale_symbols_by(country: 'DE', language: 'pl')).to eq(expected_locales)
      end
    end
  end
end
