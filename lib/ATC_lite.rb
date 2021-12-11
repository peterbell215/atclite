# frozen_string_literal: true
require_relative "ATC_lite/version"
require_relative 'ATC_lite/ATC_screen'
require_relative 'ATC_lite/aircraft'

module ATCLite
  class Error < StandardError; end

  def self.run
    aircraft = Aircraft.new(x: 100, y: 100)

    ATCScreen.instance.add_aircraft(aircraft)

    ATCScreen.instance.start
  end
end


