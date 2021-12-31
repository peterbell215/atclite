# frozen_string_literal: true

require 'active_support'
require 'great-circle'

require_relative "ATC_lite/version"
require_relative 'ATC_lite/ATC_screen'
require_relative 'ATC_lite/navigation'
require_relative 'ATC_lite/flightplan'

require_relative 'ATC_lite/aircraft'
require_relative 'ATC_lite/aircraft_performance_entry'
require_relative 'ATC_lite/aircraft_performance'
require_relative 'ATC_lite/aircraft_renderer'
require_relative 'ATC_lite/altitude'

module ATCLite
  class Error < StandardError; end

  def self.run
    aircraft = Aircraft.new(x: 100, y: 100)

    ATCScreen.instance.add_aircraft(aircraft)

    ATCScreen.instance.start
  end
end


