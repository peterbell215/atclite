# frozen_string_literal: true

require 'rspec'

RSpec.describe AircraftPerformanceEntry do
  describe '#initialize' do
    context 'when the performance data is fully specified' do
      subject(:aircraft_performance_entry) do
        AircraftPerformanceEntry.new(phase: :initial_climb, ias: 250, roc: 1000, lower_altitude: 4000,
                                              upper_altitude: 6000)
      end

      specify { expect(aircraft_performance_entry.phase).to eq(:initial_climb) }
      specify { expect(aircraft_performance_entry.ias).to eq(250) }
      specify { expect(aircraft_performance_entry.roc).to eq(1000) }
      specify { expect(aircraft_performance_entry.lower_altitude).to eq(Altitude.new(4000)) }
    end

    context 'when the hash is incomplete' do
      let(:parameters_with_missing_ias) { { phase: :initial_climb, roc: 1000, lower_altitude: 4000.ft, upper_altitude: 6000.ft } }

      it 'raises an appropriate error' do
        expect { AircraftPerformanceEntry.new(**parameters_with_missing_ias) }
          .to raise_error(MissingAttributesError)
      end
    end
  end

  describe '#altitude_in_range' do
    subject(:aircraft_performance_entry) do
      AircraftPerformanceEntry.new(phase: :initial_climb, ias: 250, roc: 1000, lower_altitude: 4000.ft,
                                   upper_altitude: 6000.ft)
    end

    specify { expect(aircraft_performance_entry.altitude_in_range(3000.ft)).to be_falsey }
    specify { expect(aircraft_performance_entry.altitude_in_range(4000.ft)).to be_truthy }
    specify { expect(aircraft_performance_entry.altitude_in_range(5000.ft)).to be_truthy }
    specify { expect(aircraft_performance_entry.altitude_in_range(6000.ft)).to be_truthy }
    specify { expect(aircraft_performance_entry.altitude_in_range(7000.ft)).to be_falsey }
  end
end
