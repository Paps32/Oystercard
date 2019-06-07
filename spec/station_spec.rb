require 'station'

describe Station do
  subject { described_class.new(name: "Aldgate East", zone: 1) }

  it 'receives name of station' do
    expect(subject.name).to eq("Aldgate East")
  end

  it 'receives zone of station' do
    expect(subject.zone).to eq(1)
  end

end
