# frozen_string_literal: true

module ATCLite
  module Flightplan
    class FlyHeading
      def initialize(heading)
        @heading = heading
      end

      def desired_heading(_)
        @heading
      end
    end
  end
end