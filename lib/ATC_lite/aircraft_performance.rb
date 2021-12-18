# frozen_string_literal: true

require 'yaml'

require_relative 'aircraft_performance_entry'

module ATCLite
  # Class to model of a specific aircraft its performance data and provide this back to the simulator.
  class AircraftPerformance
    @performance_data = {}

    def self.performance_data
      @performance_data
    end

    # Loads the performance data from the YAML file.
    def self.load_file(filename: 'data/aircraft_performance.yaml')
      loaded_file = YAML.load_file(filename)

      loaded_file.each_pair do |aircraft_type, overall_performance_data|
        overall_performance_data.map! { |performance_data| AircraftPerformanceEntry.new(**performance_data) }
        @performance_data[aircraft_type] = overall_performance_data
      end
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
end
