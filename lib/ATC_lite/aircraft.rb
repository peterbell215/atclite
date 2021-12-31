# frozen_string_literal: true

module ATCLite
  # Details of an aircraft.
  class Aircraft
    attr_reader :callsign, :speed, :heading, :altitude, :position, :roc, :performance_data

    attr_accessor :target_heading

    KNOTS_TO_NM_PER_SECOND = 1.0 / 3600.00
    TURN_RATE_PER_SECOND = 2

    def initialize(callsign: 'BA001', type: 'A19N', speed: 0, altitude:, heading: nil, position: nil)
      @performance_data = ATCLite::AircraftPerformance.new(type)
      @callsign = callsign
      @type = type
      @speed = speed
      @target_altitude = @altitude = altitude
      @roc = 0
      @heading = @target_heading = Angle.new(heading)
      @position = position
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

    # calculates, given a speed over ground, the updated position.
    def update_position
      distance_covered_in_1_s = self.speed * KNOTS_TO_NM_PER_SECOND

      @position.new_position!(distance: distance_covered_in_1_s, heading: heading)
    end
  end
end
