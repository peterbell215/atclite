# frozen_string_literal: true

require 'ATC_lite/altitude'

module ATCLite
  # Single entry of performance data for an aircraft.  Used by AircraftPerformance
  class AircraftPerformanceEntry
    attr_accessor :phase, :ias, :roc

    attr_reader :lower_altitude, :upper_altitude

    def initialize(phase:, ias: nil, roc: nil, lower_altitude: nil, upper_altitude: nil)
      @phase = phase
      @ias = ias
      @roc = roc
      @lower_altitude = Altitude.new(lower_altitude)
      @upper_altitude = Altitude.new(upper_altitude)
    end

    def lower_altitude=(value)
      @lower_altitude = Altitude.new(value)
    end

    def upper_altitude=(value)
      @upper_altitude = Altitude.new(value)
    end
  end
end
