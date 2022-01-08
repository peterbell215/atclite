# frozen_string_literal: true

require 'yaml'

require_relative 'aircraft_performance_entry'

# Class to model of a specific aircraft its performance data and provide this back to the simulator.
class AircraftPerformance
  @performance_data_library = {}

  def self.performance_data_library
    @performance_data_library
  end

  # Loads the performance data from the YAML file.
  def self.load_file(filename: 'data/aircraft_performance.yaml')
    loaded_file = YAML.load_file(filename)

    loaded_file.each_pair do |aircraft_type, overall_performance_data|
      overall_performance_data.map! { |performance_data| AircraftPerformanceEntry.new(**performance_data) }
      @performance_data_library[aircraft_type] = overall_performance_data
    end
  end

  def initialize(type)
    @type = type
    @performance_data = AircraftPerformance.performance_data_library[@type]
    @cruise_index = @performance_data.find_index{ |performance_entry| performance_entry.phase == :cruise }
  end

  def roc(altitude, target_altitude)
    case altitude <=> target_altitude
    when 0 then 0
    when -1 then find_entry(0..@cruise_index-1, altitude).roc
    when +1 then find_entry((@cruise_index+1).., altitude).roc
    end
  end

  private

  def find_entry(range, altitude)
    @performance_data[range].find { |performance_entry| performance_entry.altitude_in_range(altitude) }
  end

end
