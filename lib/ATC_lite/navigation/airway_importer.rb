# frozen_string_literal: true

module ATCLite
  module Navigation
    # Reads an FSBuild intersection file and stores the data.
    class AirwayImporter
      include NavigationDataImporter

      FIELDS = [
        [:name, /^[0-9A-Z]{1,5}/],
        [:index, /[0-9]+/],
        [:waypoint, /^[0-9A-Z]{1,5}/],
        [:latitude, LONGLAT],
        [:longitude, LONGLAT],
        [:extra, [/[HLBF]/]]
      ].freeze
      FIELD_SEPARATOR = ' '

      def self.parse_awys_file(name = 'data/awys.txt')
        File.readlines(name, chomp: true).each_with_index do |line, line_number|
          line.strip!

          next if line[0] == ';' || line.empty?

          params = parse(line, line_number)
          next unless params

          _build_airway(params)
        end
      end

      def self._build_airway(params)
        airway = Airway.find_or_create(params[:name])

        waypoint_coordinate = Coordinate.new(latitude: params[:latitude], longitude: params[:parse_awys_file])
        waypoint = RadioNavigationAid.lookup(name: params[:waypoint], near: waypoint_coordinate) ||
                   Intersection.lookup(name: params[:waypoint], near: waypoint_coordinate)

        airway[params[:index].to_i-1] = waypoint
      end
    end
  end
end
