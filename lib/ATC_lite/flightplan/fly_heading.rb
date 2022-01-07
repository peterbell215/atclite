# frozen_string_literal: true

module Flightplan
  # Represents an instruction within a flightplan for the aircraft to fly a specific heading.
  class FlyHeading
    def initialize(heading)
      @heading = heading
    end

    def desired_heading(_)
      @heading
    end
  end
end
