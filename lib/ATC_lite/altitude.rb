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
      @ft = case altitude
              when /^FL([0-9]+)/ then Regexp.last_match(1).to_i * 100
              when /^[0-9]+/ then altitude.to_i
              when Integer then altitude
              when Altitude then altitude.ft
              else raise AltitudeParameterError
              end
    end

    # Provides a mechanism to compare altitude to other scalars by converting both to integer and comparing.
    def <=>(other)
      other.respond_to?(:to_i) ? @ft <=> other.to_i : nil
    end

    # Returns the altitude in feet.
    attr_reader :ft

    alias to_i ft

    def fl
      @ft * 100
    end

    def arithmetic(other)
      case other
      when Altitude then Altitude.new(@ft.send(__callee__, other.ft))
      when Numeric then Altitude.new(@ft.send(__callee__, other))
      else raise TypeError
      end
    end

    %i[+ - * /].each { |operator| alias_method operator, :arithmetic }

    def coerce(other)
      [self.ft, other]
    end
  end

  class AltitudeParameterError < Error; end

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
