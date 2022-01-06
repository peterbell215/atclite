# frozen_string_literal: true

module ATCLite
  # Details of an aircraft.
  class Aircraft
    KNOTS_TO_NM_PER_SECOND = 1.0 / 3600.00
    TURN_RATE_PER_SECOND = 2

    attr_reader :callsign, :type, :speed, :heading, :altitude, :position, :roc, :performance_data, :flightplan
    attr_accessor :target_heading, :target_altitude

    # Build an aircraft with defined key parameters.  Once created, only aircraft object can update itself.
    def self.build(callsign:, type:, altitude:, position:, speed: 0.knots, heading: 0.degrees)
      aircraft = Aircraft.new(callsign: callsign, type: type)

      aircraft.instance_eval do
        self.position = position.dup
        self.speed = speed
        self.heading = heading.is_a?(Angle) ? heading : heading.degrees
        self.altitude = altitude
      end
      aircraft
    end

    # Create an aircraft from a flightplan.  In this case, the aircraft positoon is set to be at the departure airport.
    # The altitude is set to the departure airport's altitude.  Speed is set to zero.  Heading is to zero.
    def self.file_flightplan(callsign:, type:, flightplan:)
      aircraft = Aircraft.new(callsign: callsign, type: type)
      departure_airport = flightplan.departure_airport

      aircraft.instance_eval do
        self.position = departure_airport
        self.speed = 0.knots
        self.heading = self.position.initial_heading_to flightplan.current
        self.altitude = departure_airport.altitude
      end
      aircraft
    end

    # Create an aircraft object with a given callsign and of a particular type.
    def initialize(callsign: 'BA001', type: 'A19N')
      @callsign = callsign
      @type = type
      @performance_data = ATCLite::AircraftPerformance.new(type)
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

    private

    attr_writer :speed, :heading

    def position=(value)
      @position = value.dup
    end

    # Altitude setter that also converts to the Altitude class if it is not.
    def altitude=(value)
      @altitude = value.is_a?(Altitude) ? value : Altitude.new(value)
    end
  end
end
