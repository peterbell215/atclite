# frozen_string_literal: true

module ATCLite
  module Navigation
    # Flightplan describes the flightplan the aircraft is following.  It is made up of a sequence of paths with the
    # first element of the sequence being the current active path being followed.
    class Flightplan
      attr_reader :cruise_altitude, :phase, :speed

      def starting_phase
        :initial_climb
      end

      def initialize(initial_phase:, initial_speed, )
        @phase = flightplan.phase
        @speed = flightplan.speed
        self.altitude = flightplan.altitude
        self.target_altitude = flightplan.altitude
        @roc = 0
        @heading = flightplan.heading
        @target_heading = flightplan.heading
      end

    end
  end
end
