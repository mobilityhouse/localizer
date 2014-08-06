describe Localizer::ConfigReader do
  let(:reader) { described_class.new }

  it 'return default locale from file' do
    expect(reader.default_locale).to eq 'en-GB'
  end

  it 'returns list of countries' do
    expect(reader.countries).to eq 'CH' => %w(de fr it), 'BE' => %w(pl nl de)
  end
end
