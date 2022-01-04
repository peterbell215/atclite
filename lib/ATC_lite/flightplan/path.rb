# frozen_string_literal: true

module ATCLite
  module Flightplan
    class Path < Array
      attr_reader :waypoints

      def initialize(string:, close_to:)
        build_path(string, close_to)
      end

      def to_s
        self.map(&:to_s).join(' ')
      end

      private

      # Given a string of the form 'UMLAT T418 WELIN T420 TNT UN57 POL UN601 INPIP' build a path in the @waypoint
      # array. The string has the form: 'Waypoint [Waypoint | Jetway Waypoint]*'.  If a waypoint is followed by
      # a airway and a waypoint, then the path includes all waypoints from the initial waypoint along the airway
      # to the specified airway.  In our example, UMLAT T418 WELIN provides UMLAT ? WELIN.  If a waypoint is followed
      # by another waypoint it is considered a direct routing.
      def build_path(string, close_to)
        string.split.inject(nil) do |previous, current|
          case previous
          in nil then _first_waypoint(current, close_to)
          in Navigation::Airway => airway, Navigation::Waypoint => airway_entry, Integer => airway_entry_index
            _along_airway(airway, airway_entry, airway_entry_index, current)
          else _next(current, previous)
          end
        end
      end

      def _first_waypoint(current, close_to)
        first_waypoint = Navigation::Waypoint.lookup(current, close_to)
        self.push(first_waypoint)
        first_waypoint
      end

      # Determines whether the current string identifier is an airway or a waypoint.
      def _next(current, previous)
        airway = Navigation::Airway.lookup(current)
        if airway
          airway_entry_index = airway.index(previous)
          [airway, previous, airway_entry_index]
        else
          waypoint = Navigation::Waypoint.lookup(current, previous)
          self.push(waypoint)
          waypoint
        end
      end

      # If we are passed a previous waypoint and a jetway, inserts the intermedite waypoints on the airway.
      def _along_airway(airway, airway_entry, airway_entry_index, current)
        airway_exit = Navigation::Waypoint.lookup(current, airway_entry)
        airway_exit_index = airway&.index(airway_exit)

        nxt_waypoints = if airway_entry_index <= airway_exit_index
                          airway[airway_entry_index + 1..airway_exit_index]
                        else
                          airway[airway_exit_index..airway_entry_index - 1].reverse!
                        end
        self.concat(nxt_waypoints)

        airway_exit
      end
    end
  end
end
