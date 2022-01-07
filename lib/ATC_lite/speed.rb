# frozen_string_literal: true


# Class to represent an speed.  Speeds can either be defined in knots or mach.  The object is aware how the speed
# was set, and automatically manages conversion if speed is requested in the alternative unit.
class Speed
  include Comparable

  # Define the speed either in knots or in mach.
  def initialize(speed = nil, mach: nil)
    if mach
      @mach = mach.to_f
    else
      @knots = speed.to_i
    end
  end

  # Return the speed as a mach number.  If the speed was set as a mach number, simply returns the original setting.
  # If set as knots and if the altitude adjusts for them.  Includes the temperature to allow for a temperature
  # adjustment as well.
  def mach(altitude: nil, temperature: nil)
    @mach || @knots / mach_1_for_altitude_and_temperature(altitude, temperature)
  end

  # Return the speed as a mach number.  If the speed was set as a mach number, simply returns the original setting.
  # If set as knots and if the altitude adjusts for them.  Includes the temperature to allow for a temperature
  # adjustment as well.
  def knots(altitude: nil, temperature: nil)
    @knots || @mach * mach_1_for_altitude_and_temperature(altitude, temperature)
  end

  private

  # Table the provides the speed of sound at altitudes 5000ft apart.  Above FL 350, speed of sound is close to
  # constant
  #
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

  # Private method that interpolates the speed of sound for a give altitude.
  # @todo: needs to add adjusting for temperature
  def mach_1_for_altitude_and_temperature(altitude, _temperature)
    SPEED_OF_SOUND_BY_FL.each_cons(2) do |lower, higher|
      next unless altitude.between? lower[:altitude], higher[:altitude]

      delta_knots = (higher[:knots] - lower[:knots])
      return lower[:knots] + (delta_knots * (altitude - lower[:altitude]) / 5000.0)
    end

    SPEED_OF_SOUND_BY_FL.last[:knots]
  end
end

# Add the ability to write: 0.8.mach to create an appropriate Speed object
class ::Float
  def mach
    Speed.new(mach: self)
  end
end

# Add the ability to write: 245.knots to create an appropriate Speed object
class ::Numeric
  def knots
    Speed.new(self)
  end
end
