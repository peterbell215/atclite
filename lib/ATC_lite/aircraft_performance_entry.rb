# frozen_string_literal: true

require 'ATC_lite/altitude'

# Single entry of performance data for an aircraft.  Used by AircraftPerformance
class AircraftPerformanceEntry
  VALID_DATA_FOR_PERFORMANCE_FILE = {
    initial_climb: %i[ias roc upper_altitude],
    climb: %i[ias roc lower_altitude],
    cruise: %i[ias upper_altitude],
    initial_descent: %i[roc lower_altitude],
    descent: %i[roc ias upper_altitude lower_altitude],
    approach: %i[roc ias upper_altitude lower_altitude]
  }.freeze

  def self.check_validity_of_performance_data(performance_data)
    raise InvalidPhaseError unless VALID_DATA_FOR_PERFORMANCE_FILE.key?(performance_data[:phase])

    mandatory_attributes = VALID_DATA_FOR_PERFORMANCE_FILE[performance_data[:phase]]
    missing_attributes = mandatory_attributes - performance_data.keys
    missing_attributes.empty? || raise(MissingAttributesError.new(performance_data[:phase], missing_attributes))
  end

  attr_accessor :phase, :roc

  attr_reader :lower_altitude, :upper_altitude, :ias

  def initialize(**performance_data)
    @phase = performance_data[:phase]

    AircraftPerformanceEntry.check_validity_of_performance_data(performance_data)
    self.ias = performance_data[:ias]
    @roc = performance_data[:roc] || 0
    self.lower_altitude = performance_data[:lower_altitude] || 0.ft
    self.upper_altitude = performance_data[:upper_altitude] || 100_000.ft
  end

  def ias=(value)
    @ias = if value.is_a?(Float) && value.between?(0.0, 1.0)
             Speed.new(mach: value)
           else
             Speed.new(value)
           end
  end

  def lower_altitude=(value)
    @lower_altitude = Altitude.new(value)
  end

  def upper_altitude=(value)
    @upper_altitude = Altitude.new(value)
  end

  def altitude_in_range(altitude)
    (self.lower_altitude.nil? || self.lower_altitude <= altitude) &&
      (self.upper_altitude.nil? || altitude <= self.upper_altitude)
  end
end

# Error raised if the phase is invalid.
class InvalidPhaseError < StandardError; end

# Error raised if an attribute required for a specific phase is missing
class MissingAttributesError < StandardError
  def initialize(phase, missing_attributes)
    super("phase #{phase} is missing attributes #{missing_attributes}")
  end
end
