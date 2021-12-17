# frozen_string_literal: true

require 'yaml'

require_relative 'aircraft_performance_entry'

module ATCLite
  # Class to model of a specific aircraft its performance data and provide this back to the simulator.
  class AircraftPerformance
    VALID_DATA_FOR_PERFORMANCE_FILE = {
      initial_climb: %i[ias roc upper_altitude],
      climb: %i[ias roc lower_altitude],
      cruise: %i[ias upper_altitude],
      initial_descent: %i[roc lower_altitude],
      descent: %i[roc ias upper_altitude lower_altitude],
      approach: %i[roc ias upper_altitude lower_altitude]
    }.freeze

    @performance_data = {}

    # Loads the performance data from the YAML file.
    def self.load_file(filename: 'data/aircraft_performance.yaml')
      loaded_file = YAML.load_file(filename)

      loaded_file.each_pair do |aircraft_type, overall_performance_data|
        overall_performance_data.map! do |performance_data|
          check_validity_of_performance_data(performance_data)
          AircraftPerformanceEntry.new(**performance_data)
        end
        @performance_data[aircraft_type] = overall_performance_data
      end
    end

    def self.performance_data
      @performance_data
    end

    def self.check_validity_of_performance_data(performance_data)
      raise InvalidPhaseError unless VALID_DATA_FOR_PERFORMANCE_FILE.key?(performance_data[:phase])

      mandatory_attributes = VALID_DATA_FOR_PERFORMANCE_FILE[performance_data[:phase]]
      missing_attributes = mandatory_attributes - performance_data.keys
      missing_attributes.empty? || raise(MissingAttributesError.new(performance_data[:phase], missing_attributes))
    end

    def initialize(type)
      @type = type
    end

    def roc(altitude, phase:)
      data = AircraftPerformance.performance_data[@type].find do |performance_entry|
        performance_entry.phase == phase &&
          altitude.between?(performance_entry.lower_altitude || 0.ft, performance_entry.upper_altitude || 100_000.ft)
      end
      data&.roc
    end
  end

  # Error raised if the phase is invalid.
  class InvalidPhaseError < StandardError; end

  # Error raised if an attribute required for a specific phase is missing
  class MissingAttributesError < StandardError
    def initialize(phase, missing_attributes)
      super("phase #{@phaser} is missing attributes #{missing_attributes}")
    end
  end
end
