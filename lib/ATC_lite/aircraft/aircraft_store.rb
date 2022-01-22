# frozen_string_literal: true

require 'singleton'

module Aircraft
  # This
  class AircraftStore
    include Singleton

    def initialize
      @aircraft = []
    end

    def add_aircraft(aircraft)
      @aircraft.push(aircraft)
    end

    def start
      @simulation_thread = Thread.new do
        loop do
          sleep 1
          @aircraft.each(&:update)
        end
      end
    end
  end
end
