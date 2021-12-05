# frozen_string_literal: true
require 'ruby2d'
require 'singleton'

require_relative 'aircraft_renderer'

module ATCLite
  # include Ruby2D

  class ATCScreen
    include Singleton

    def initialize
      @aircraft_renderers = []
    end

    def start
      @aircraft_renderers.each(&:update)

      Window.set title: "ATC Lite"
      Window.show
    end

    def add_aircraft(aircraft)
      @aircraft_renderers.push(AircraftRenderer.new(aircraft))
    end
  end
end
