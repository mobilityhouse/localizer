describe Localizer::Locale do
  subject { described_class.new(identifier) }

  describe '#language_only?' do
    context 'when locale is language only' do
      let(:identifier) { 'pl' }

      it 'returns true' do
        expect(subject.language_only?).to eq true
      end
    end

    context 'when locale contains both language and country' do
      let(:identifier) { 'pl-PL' }

      it 'returns false' do
        expect(subject.language_only?).to eq false
      end
    end
  end

  describe '#parent' do
    let(:identifier) { 'pl-PL' }

    it 'returns only language locale' do
      expect(subject.parent).to eq described_class.new(identifier.split('-').first)
    end
  end

  describe '#fallbacks' do
    context 'when locale is language only' do
      let(:identifier) { 'pl'}

      it 'returns array containing self symbol' do
        expect(subject.fallbacks).to eq [described_class.new(identifier)]
      end
    end

    context 'when locale contains both language and country' do
      let(:identifier) { 'pl-PL' }

      it 'returns array containing parent locale' do
        expect(subject.fallbacks).to eq [described_class.new('pl')]
      end
    end
  end
end
