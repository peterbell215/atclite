# frozen_string_literal: true

module ATCLite
  # Class to represent an altitude.  Is aware of the difference between ft and FL.
  class Altitude
    include Comparable

    @@transition_altitude = 6000

    def self.transition_altitude=(arg)
      @@transition_altitude = arg
    end

    def self.transition_altitude
      @@transition_altitude
    end

    def initialize(altitude)
      case altitude
      when /FL([0-9]{3})/
        @feet = Regexp.last_match(1).to_i * 1000
      when Integer
        @feet = altitude
      when Altitude
        @feet = altitude.ft
      else
        raise AltitudeParameterError
      end
    end

    # Provides a mechanism to compare altitude to other scalars by converting both to integer and comparing.
    def <=>(operand)
      operand.respond_to?(:to_i) ? @feet <=> operand.to_i : nil
    end

    # Returns the altitude in feet.
    def ft
      @feet
    end

    alias to_i ft

    def fl
      @flight_level / 1000
    end

    def cooerce(value)
      [self, Altitude.new(value)]
    end
  end

  class AltitudeParameterError < Error; end

  # Add the ability to write:
  # * 1000.ft to create an Altitude object at 1000 ft
  class ::Integer
    def ft
      Altitude.new(self)
    end
  end
end

