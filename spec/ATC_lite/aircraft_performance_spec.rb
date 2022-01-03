require 'rspec'

RSpec.describe ATCLite::AircraftPerformance do
  subject(:aircraft_performance) { ATCLite::AircraftPerformance.new('A19N') }

  before { ATCLite::AircraftPerformance.load_file }

  describe 'Initialization from file' do
    specify { expect(aircraft_performance).not_to be_nil }
  end

  describe '#roc' do
    specify { expect(aircraft_performance.roc(4000.ft, phase: :initial_climb)).to eq(2500) }
  end

  describe '#match_phase' do
    it 'identifies an aircraft established in the cruise' do
      aircraft = ATCLite::Aircraft.new(altitude: 350.fl)
      expect(aircraft_performance.match_phase(aircraft)).to eq :cruise
    end
  end
end
