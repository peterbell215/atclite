# frozen_string_literal: true

module Aircraft
  # Details of an aircraft.
  class Aircraft
    KNOTS_TO_NM_PER_SECOND = 1.0 / 3600.00
    TURN_RATE_PER_SECOND = 2

    attr_reader :callsign, :type, :speed, :heading, :altitude, :target_altitude, :position, :roc, :performance_data,
                :flightplan, :phase
    attr_accessor :target_heading

    # Build an aircraft with defined key parameters.  Once created, only aircraft object can update itself.
    def self.build(callsign:, type:, altitude:, position:, speed: 0.knots, heading: 0.degrees)
      aircraft = Aircraft.new(callsign: callsign, type: type)

      aircraft.instance_eval do
        self.position = position.dup
        self.speed = speed
        self.heading = heading.is_a?(Angle) ? heading : heading.degrees
        self.altitude = altitude
        self.phase = :climb
      end
      aircraft
    end

    # Create an aircraft from a flightplan.  In this case, the aircraft positoon is set to be at the departure airport.
    # The altitude is set to the departure airport's altitude.  Speed is set to zero.  Heading is to zero.
    def self.file_flightplan(callsign:, type:, flightplan:)
      aircraft = Aircraft.new(callsign: callsign, type: type)
      departure_airport = flightplan.departure_airport

      aircraft.instance_eval do
        self.position = departure_airport.dup
        self.speed = 0.knots
        self.heading = self.position.initial_heading_to flightplan.current
        self.altitude = departure_airport.altitude
        self.phase = :takeoff
      end
      aircraft
    end

    # Create an aircraft object with a given callsign and of a particular type.
    def initialize(callsign: 'BA001', type: 'A19N')
      @callsign = callsign
      @type = type
      @performance_data = AircraftPerformance.new(type)
      @position_history = []
      @monitor = Monitor.new
    end

    # Set the target altitude
    def target_altitude=(value)
      @target_altitude = Altitude.new(value)
    end

    def update
      update_position
    end

    # Standard aircraft turn is 180 degrees per min, or 2 degrees per second
    def update_heading
      @monitor.synchronize do
        return if @target_heading == @heading

        delta = (@target_heading - @heading)
        delta += 360 if delta < -180
        delta -= 360 if delta > 180

        delta = [-TURN_RATE_PER_SECOND, delta].max
        delta = [delta, TURN_RATE_PER_SECOND].min

        @heading += delta
        @heading.abs!
      end
    end

    # calculates, given a speed over ground, the updated position.
    def update_position
      @monitor.synchronize do
        distance_covered_in_1_s = self.speed * KNOTS_TO_NM_PER_SECOND

        self.position = self.position.new_position(distance: distance_covered_in_1_s, heading: heading)
      end
    end

    private

    attr_writer :speed, :heading, :phase

    def position=(value)
      @position = value
    end

    # Altitude setter that also converts to the Altitude class if it is not.
    def altitude=(value)
      @altitude = value.is_a?(Altitude) ? value : Altitude.new(value)
    end
  end
end
