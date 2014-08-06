describe Localizer::LocalesService do
  subject { described_class.new('oem') }

  let(:locales) {
    { 'oem' => ['pl-PL', 'de-DE', 'fr-DE', 'en-US', 'en-GB'] }
  }

  before do
    allow(described_class).to receive(:configuration).and_return(locales)
    I18n.available_locales = subject.available_locales_array
    I18n.fallbacks = subject.fallbacks_hash
  end

  describe '#fallbacks_hash' do
    let(:fallbacks_hash) {
      {
        :'pl-PL' => [:pl],
        :'de-DE' => [:de],
        :'fr-DE' => [:fr],
        :'en-US' => [:en],
        :'en-GB' => [:en],
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

  describe '#available_locales_array' do
    let(:available_locales) {
      [:'pl-PL', :'de-DE', :'fr-DE', :'en-US', :'en-GB', :pl, :de, :fr, :en]
    }

    it 'returns array of available locales' do
      expect(subject.available_locales_array).to eq(available_locales)
    end
  end

  describe '#languages' do
    let(:languages) {
      [Localizer::Locale.new('pl'), Localizer::Locale.new('de'), Localizer::Locale.new('fr'), Localizer::Locale.new('en')]
    }

    it 'returns list of locales' do
      expect(subject.languages).to eq(languages)
    end
  end

  describe '#by_country' do
    let(:languages) { [Localizer::Locale.new('fr-DE'), Localizer::Locale.new('de-DE')] }

    it 'returns list of locales for given country' do
      expect(subject.by_country('DE')).to match_array(languages)
    end
  end

  describe '#by_country_and_language' do
    context 'when both country and language are given' do
      let(:languages) { [:'pl-PL'] }

      it 'returns list of locales' do
        expect(subject.symbols_by_country_and_language('PL', 'pl')).to eq(languages)
      end
    end

    context 'when country is nil' do
      let(:languages) { [:'de-DE'] }

      it 'returns all locales with matching language' do
        expect(subject.symbols_by_country_and_language(nil, 'de')).to eq(languages)
      end
    end
  end
end
