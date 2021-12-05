# frozen_string_literal: true
require_relative "ATC_lite/version"
require_relative 'ATC_lite/ATC_screen'
require_relative 'ATC_lite/aircraft'

module ATCLite
  class Error < StandardError; end
  # Your code goes here...

  aircraft = Aircraft.new
  aircraft.x = 100
  aircraft.y = 100

  ATCScreen.instance.add_aircraft(aircraft)

  ATCScreen.instance.start
end


