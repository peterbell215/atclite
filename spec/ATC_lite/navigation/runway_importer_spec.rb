# frozen_string_literal: true

require 'rspec'

RSpec.describe Navigation::RunwayImporter do
  describe '::match' do
    context 'when its an ILS equipped runway' do
      subject(:runway) { described_class.match('09L_12799_51.477500_-0.484992_089_110.30', 1) }

      specify { expect(runway.name).to eq '09L' }
      specify { expect(runway.length).to eq 12_799 }
      specify { expect(runway.latitude).to eq Latitude.new(51.477500) }
      specify { expect(runway.longitude).to eq Longitude.new(-0.484992) }
      specify { expect(runway.heading).to eq 89 }
      specify { expect(runway.ils).to eq '110.30' }
    end

    context 'when the runway does not have an ILS' do
      subject(:runway) { described_class.match('07_4380_51.322547_-0.854633_071_---', 1) }

      specify { expect(runway.name).to eq '07' }
      specify { expect(runway.length).to eq 4_380 }
      specify { expect(runway.latitude).to eq Latitude.new(51.322547) }
      specify { expect(runway.longitude).to eq Longitude.new(-0.854633) }
      specify { expect(runway.heading).to eq 71 }
      specify { expect(runway.ils).to be_nil }
    end
  end
end
