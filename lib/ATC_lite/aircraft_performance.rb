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
  end

  def roc(altitude, target_altitude)
    data = @performance_data.find do |performance_entry|
      performance_entry.phase == phase &&
        altitude.between?(performance_entry.lower_altitude || 0.ft, performance_entry.upper_altitude || 100_000.ft)
    end
    data&.roc
  end

  # Matching the flight phase to the aircraft is a little involved:
  # * If the aircraft is at climbing or descending, then the phase is determined by the altitude.
  # * if the aircraft is travelling level, then
  def match_phase(aircraft)
    case aircraft.altitude <=> aircraft.target_altitude
    when 0 then _level_flight(aircraft)
    when -1 then _climb
    when +1 then _descent
    end
  end

  private

  # Determine if the aircraft is in level flight what phase of the flight it is in.
  def _level_flight(aircraft)
    if aircraft.altitude >= @cruise_data.lower_altitude
      :cruise
    else
      _find_phase(ATCLite::AircraftPerformanceEntry.PERMISSIBLE_PHASE_TRANSITIONS[aircraft.phase])
    end
  end

  def _climb
    _find_phase %i[initial_climb climb]
  end

  def _descent
    _find_phase %i[descent approach]
  end

  def _find_phase(possible_phases)
    @performance_data.find do |performance_entry|
      performance_entry.phase.in?(possible_phases) &&
        altitude.between?(performance_entry.lower_altitude || 0.ft, performance_entry.upper_altitude || 100_000.ft)
    end
  end
end
