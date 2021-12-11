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
      @scale = 10
      @centre_x = 100
      @centre_y = 100
    end

    attr_reader :centre_x, :centre_y

    def start
      Window.set title: 'ATC Lite'

      tick = 0

      Window.update do
        if (tick % 60).zero?
          @aircraft_renderers.map(&:aircraft).each(&:update_position)
          @aircraft_renderers.each(&:update)
        end
        tick += 1
      end

      Window.show
    end

    # Maps a x position in the simulator space to a x coordinate on the ATC screen based on the ATC screen centre and
    # scale.
    def map_x(x)
      (x - @centre_x) * @scale + Window.width / 2
    end

    # Maps a y position in the simulator space to a y coordinate on the ATC screen based on the ATC screen centre and
    # scale.
    def map_y(y)
      (y - @centre_y) * @scale + Window.height / 2
    end

    def add_aircraft(aircraft)
      @aircraft_renderers.push(AircraftRenderer.new(aircraft))
    end
  end
end
