# frozen_string_literal: true

module ATCLite
  # Details of an aircraft.
  class Aircraft
    attr_reader :callsign, :speed, :heading, :altitude, :position, :roc, :performance_data, :flightplan

    attr_accessor :target_heading, :target_altitude

    KNOTS_TO_NM_PER_SECOND = 1.0 / 3600.00
    TURN_RATE_PER_SECOND = 2

    def initialize(callsign: 'BA001', type: 'A19N', flightplan:)
      @callsign = callsign
      @type = type
      @performance_data = ATCLite::AircraftPerformance.new(type)
      @flightplan = flightplan

      set_state_from_flightplan
    end

    def set_state_from_flightplan
      @position = flightplan.departure_airport
      @target_altitude = @altitude = flightplan.departing_airport.altitude
      @speed = 0.knots
      @roc = 0
      @heading = @position.initial_heading_to(flightplan.next_waypoint)
    end

    # Altitude setter that also converts to the Altitude class.
    def altitude=(value)
      @altitude = Altitude.new(value)
    end

    def target_altitude=(value)
      @target_altitude = Altitude.new(value)
    end

    # standard aircraft turn is 180 degrees per min, or 2 degrees per second
    def update_heading
      return if @target_heading == @heading

      delta = (@target_heading - @heading)
      delta += 360 if delta < -180
      delta -= 360 if delta > 180

      delta = [-TURN_RATE_PER_SECOND, delta].max
      delta = [delta, TURN_RATE_PER_SECOND].min

      @heading += delta
      @heading.abs!
    end

    # Based on current altitude and target altitude, adjust the current altitude and phase of the flight
    def update_altitude_and_phase
      case @altitude <=> @target_altitude
      when 0
        @phase = self.performance_data.match_phase(self)
      end
    end

    # calculates, given a speed over ground, the updated position.
    def update_position
      distance_covered_in_1_s = self.speed * KNOTS_TO_NM_PER_SECOND

      @position.new_position!(distance: distance_covered_in_1_s, heading: heading)
    end
  end
end
