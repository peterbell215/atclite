# frozen_string_literal: true

require 'rspec'

RSpec.describe ATCLite::Navigation::AirportImporter do
  describe '::parse_apts_file' do
    subject(:egll) { ATCLite::Navigation::Airport.lookup('EGLL') }

    # rubocop: disable RSpec/BeforeAfterAll the data is read in read-only so no danger of state
    #                                       leakage.  Its a large data file so reading once rather
    #                                       than for every test is better.
    before(:all) { described_class.parse_apts_file }

    after(:all) { ATCLite::Navigation::Airport.clear_data }
    # rubocop: enable RSpec/BeforeAfterAll

    specify { expect(egll.name).to eq 'EGLL' }
    specify { expect(egll.fullname).to eq 'HEATHROW' }
    specify { expect(egll.altitude).to eq ATCLite::Altitude.new(83) }
    specify { expect(egll.latitude).to eq 51.477500 }
    specify { expect(egll.longitude).to eq(-0.461389) }
    specify { expect(egll.runways.size).to eq 4 }
    specify { expect(egll.runways[0].name).to eq '09L' }
  end

  describe '::parse' do
    context 'when it is a multi-runway airport' do
      subject(:airport_hash) do
        airport_core_data = 'EGLL  HEATHROW    83 51.477500    -0.461389'

        described_class.parse("#{airport_core_data}  #{runway_9l} #{runway_9r} #{runway_27l} #{runway_27r}", 1)
      end

      let(:runway_9l) { '09L_12799_51.477500_-0.484992_089_110.30' }
      let(:runway_9r) { '09R_12001_51.464792_-0.482314_089_109.50' }
      let(:runway_27l) { '27L_12001_51.464950_-0.434100_269_109.50' }
      let(:runway_27r) { '27R_12799_51.477675_-0.433283_269_110.30' }

      specify { expect(airport_hash[:name]).to eq 'EGLL' }
      specify { expect(airport_hash[:fullname]).to eq 'HEATHROW' }
      specify { expect(airport_hash[:altitude]).to eq '83' }
      specify { expect(airport_hash[:latitude]).to eq '51.477500' }
      specify { expect(airport_hash[:longitude]).to eq '-0.461389' }
      specify { expect(airport_hash[:runways].size).to eq 4 }

      it 'matches each runway with the indexed in the airport object' do
        [runway_9l, runway_9r, runway_27l, runway_27r].each_with_index do |runway, index|
          expect(airport_hash[:runways][index]).to eq ATCLite::Navigation::RunwayImporter.match(runway, 1)
        end
      end
    end
  end

  describe '::output' do
    subject(:airport) do
      ATCLite::Navigation::Airport.new(name: 'EGLL',
                                       fullname: 'HEATHROW',
                                       altitude: 83.ft,
                                       latitude: Latitude.new(51.477500), longitude: Longitude.new(-0.484992),
                                       runways: [runway_9l])
    end

    let(:runway_9l) do
      ATCLite::Navigation::Runway.new(name: '09L', length: 12_799, latitude: 51.477500, longitude: -0.484992,
                                      heading: 89, ils: '110.30')
    end

    it 'generates the correct string' do
      expect(described_class.output(airport))
        .to eq 'EGLL HEATHROW 83ft 51.477500 -0.484992 09L_12799_51.477500_-0.484992_89_110.30'
    end
  end
end
