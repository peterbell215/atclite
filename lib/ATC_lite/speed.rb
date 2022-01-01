# frozen_string_literal: true

module ATCLite
  # Class to represent an altitude.  Is aware of the difference between ft and FL.
  class Speed
    include Comparable

    def initialize(speed = nil, mach: nil)
      if mach
        @mach = mach.to_f
      else
        @knots = speed.to_i
      end
    end

    def mach(altitude: nil, temperature: nil)
      @mach || @knots / mach_1_for_altitude_and_temperature(altitude, temperature)
    end

    def knots(altitude: nil, temperature: nil)
      @knots || @mach * mach_1_for_altitude_and_temperature(altitude, temperature)
    end

    private

    # rubocop: disable Layout/ExtraSpacing - array laid out for easier reading
    # rubocop: disable Layout/SpaceInsideArrayLiteralBrackets
    SPEED_OF_SOUND_BY_FL = [
      #    alt, Celsius, knots
      { altitude:   0.fl, celsius:  15.0, knots: 661.0 },
      { altitude:  50.fl, celsius:   5.1, knots: 650.0 },
      { altitude: 100.fl, celsius:  -4.8, knots: 638.0 },
      { altitude: 150.fl, celsius: -14.7, knots: 626.0 },
      { altitude: 200.fl, celsius: -24.6, knots: 614.0 },
      { altitude: 250.fl, celsius: -34.5, knots: 602.0 },
      { altitude: 300.fl, celsius: -44.4, knots: 589.0 },
      { altitude: 350.fl, celsius: -56.0, knots: 574.0 }
    ].freeze
    # rubocop: enable Layout/ExtraSpacing
    # rubocop: enable Layout/SpaceInsideArrayLiteralBrackets

    def mach_1_for_altitude_and_temperature(altitude, temperature)
      SPEED_OF_SOUND_BY_FL.each_cons(2) do |lower, higher|
        next unless altitude.between? lower[:altitude], higher[:altitude]

        delta_knots = (higher[:knots] - lower[:knots])
        return lower[:knots] + (delta_knots * (altitude - lower[:altitude]) / 5000.0)
      end

      SPEED_OF_SOUND_BY_FL.last[:knots]
    end
  end

  # Add the ability to write:
  # * 1000.ft to create an Altitude object at 1000 ft
  class ::Integer
    def ft
      Altitude.new(self)
    end

    def fl
      Altitude.new("FL#{self}")
    end
  end
end
