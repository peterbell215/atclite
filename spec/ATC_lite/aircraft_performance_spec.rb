require 'rspec'

RSpec.describe AircraftPerformance do
  subject(:aircraft_performance) { AircraftPerformance.new('A19N') }

  before { AircraftPerformance.load_file }

  describe 'Initialization from file' do
    specify { expect(aircraft_performance).not_to be_nil }
  end

  describe '#roc' do
    context 'when climbing' do
      specify { expect(aircraft_performance.roc(4000.ft, 10_000.ft)).to eq(2500) }
      specify { expect(aircraft_performance.roc(5000.ft, 10_000.ft)).to eq(2500) }
      specify { expect(aircraft_performance.roc(200.fl, 280.fl)).to eq(2200) }
      specify { expect(aircraft_performance.roc(280.fl, 330.fl)).to eq(1000) }
    end

    context 'when at level flight' do
      specify { expect(aircraft_performance.roc(4000.ft, 4000.ft)).to eq(0) }
      specify { expect(aircraft_performance.roc(5000.ft, 5000.ft)).to eq(0) }
      specify { expect(aircraft_performance.roc(200.fl, 200.fl)).to eq(0) }
      specify { expect(aircraft_performance.roc(280.fl, 280.fl)).to eq(0) }
    end

    context 'when descending' do
      specify { expect(aircraft_performance.roc(330.fl, 200.fl)).to eq(-1000) }
      specify { expect(aircraft_performance.roc(290.fl, 200.fl)).to eq(-1000) }
      specify { expect(aircraft_performance.roc(10_000.ft, 3000)).to eq(-3000) }
      specify { expect(aircraft_performance.roc(6000.ft, 3000)).to eq(-1500) }
    end
  end

end
