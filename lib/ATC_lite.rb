# frozen_string_literal: true

require 'active_support'
require 'great-circle'

require_relative 'ATC_lite/version'
require_relative 'ATC_lite/ATC_screen'
require_relative 'ATC_lite/navigation'
require_relative 'ATC_lite/flightplan'
require_relative 'ATC_lite/aircraft'

require_relative 'ATC_lite/aircraft_renderer'
require_relative 'ATC_lite/altitude'
require_relative 'ATC_lite/speed'

# Module to hold the application
module ATCLite
  def self.run
    load_data

    aircraft = Aircraft::Aircraft.build(callsign: 'BA001', type: 'A19N',
                                        speed: 200.0, heading: 0, altitude: 100.fl,
                                        position: Coordinate.new(latitude: 51.2, longitude: 0.3))

    Aircraft::AircraftStore.instance.add_aircraft(aircraft)
    Aircraft::AircraftStore.instance.start

    ATCScreen.instance.add_aircraft(aircraft)
    ATCScreen.instance.start
  end

  def self.load_data
    Aircraft::AircraftPerformance.load_file('../data/aircraft_performance.yaml')
    Navigation::RadioNavigationAidIO.parse_navs_file('../data/navs-uk.txt')
    Navigation::IntersectionIO.parse_ints_file('../data/ints-uk.txt')
    Navigation::AirwayIO.parse_awys_file('../data/awys-uk.txt')
    Navigation::AirportIO.parse_apts_file('../data/apts-uk.txt')
  end
end
