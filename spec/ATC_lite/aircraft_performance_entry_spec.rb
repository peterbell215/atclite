# frozen_string_literal: true

require 'rspec'

RSpec.describe 'ATCLite::AircraftPerformanceEntry' do
  describe '#initialize' do
    context 'when the performance data is fully specified' do
      subject(:aircraft_performance_entry) do
        ATCLite::AircraftPerformanceEntry.new(phase: :initial_climb, ias: 250, roc: 1000, lower_altitude: 4000,
                                              upper_altitude: 6000)
      end

      specify { expect(aircraft_performance_entry.phase).to eq(:initial_climb) }
      specify { expect(aircraft_performance_entry.ias).to eq(250) }
      specify { expect(aircraft_performance_entry.roc).to eq(1000) }
      specify { expect(aircraft_performance_entry.lower_altitude).to eq(ATCLite::Altitude.new(4000)) }
    end

    context 'when the hash is incomplete' do
      let(:parameters_with_missing_ias) { { phase: :initial_climb, roc: 1000, lower_altitude: 4000, upper_altitude: 6000 } }

      it 'raises an appropriate error' do
        expect { ATCLite::AircraftPerformanceEntry.new(**parameters_with_missing_ias) }
          .to raise_error(ATCLite::MissingAttributesError)
      end
    end
  end
end
