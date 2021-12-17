# frozen_string_literal: true

require 'rspec'

RSpec.describe 'ATCLite::AircraftPerformanceEntry' do
  describe '#initialize' do
    subject(:aircraft_performance_entry) do
      ATCLite::AircraftPerformanceEntry.new(phase: :initial_climb, ias: 250, roc: 1000, lower_altitude: 4000,
                                            upper_altitude: 6000)
    end

    describe 'creates an entry from a hash' do
      specify { expect(aircraft_performance_entry.phase).to eq(:initial_climb) }
      specify { expect(aircraft_performance_entry.ias).to eq(250) }
      specify { expect(aircraft_performance_entry.roc).to eq(1000) }
      specify { expect(aircraft_performance_entry.lower_altitude).to eq(ATCLite::Altitude.new(4000)) }
    end
  end
end
