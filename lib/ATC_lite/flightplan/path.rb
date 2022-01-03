# frozen_string_literal: true

module ATCLite
  module Flightplan
    class Path
      attr_reader :waypoints

      def initialize(departure_airport:, enroute:)
        @waypoints = []
        @departure_airport = Navigation::Airport.lookup(departure_airport)
        self.enroute = enroute
      end

      # Given a string of the form 'UMLAT T418 WELIN T420 TNT UN57 POL UN601 INPIP' build a path in the @waypoint
      # array. The string has the form: 'Waypoint [Waypoint | Jetway Waypoint]*'.  If a waypoint is followed by
      # a airway and a waypoint, then the path includes all waypoints from the initial waypoint along the airway
      # to the specified airway.  In our example, UMLAT T418 WELIN provides UMLAT ? WELIN.  If a waypoint is followed
      # by another waypoint it is considered a direct routing.
      def enroute=(string)
        string.split.inject(nil) do |previous, current|
          case previous
          in nil then Navigation::Waypoint.lookup(current, previous)
          in Navigation::Airway => airway, Navigation::Waypoint => airway_entry, Integer => airway_entry_index
            _along_airway(airway, airway_entry, airway_entry_index, current)
          else _next(current, previous)
          end
        end
      end

      # Returns the size of the path
      def size
        @waypoints.size
      end

      def to_s
        @waypoints.map(&:to_s).join("\n")
      end

      private

      # Determines whether the current string identifier is an airway or a waypoint.
      def _next(current, previous)
        airway = Navigation::Airway.lookup(current)
        if airway
          airway_entry_index = airway.index(previous)
          [airway, previous, airway_entry_index]
        else
          waypoint = Navigation::Waypoint.lookup(current, previous)
        end
      end

      # If we are passed a previous waypoint and a jetway, inserts the intermedite waypoints on the airway.
      def _along_airway(airway, airway_entry, airway_entry_index, current)
        airway_exit = Navigation::Waypoint.lookup(current, airway_entry)
        airway_exit_index = airway&.index(airway_exit)

        @waypoints += if airway_entry_index <= airway_exit_index
                        airway[airway_entry_index, airway_exit_index]
                      else
                        airway[airway_exit_index, airway_entry_index].reverse!
                      end
        airway_exit
      end
    end
  end
end
