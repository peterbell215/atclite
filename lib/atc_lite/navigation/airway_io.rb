# frozen_string_literal: true

module Navigation
  # Reads an FSBuild airway file and stores the data.
  class AirwayIO
    include NavigationDataIO

    def self.parse_awys_file(name = 'data/awys.txt')
      File.foreach(name, chomp: true).each_with_index do |line, line_number|
        line.strip!

        next if line[0] == ';' || line.empty?

        params = AirwaySegmentIO.parse(line, line_number)

        next unless params

        _build_airway(params)
      end
    end

    def self._build_airway(params)
      airway = Airway.find_or_create(params[:airway])
      waypoint_coordinate = Coordinate.new(latitude: params[:latitude], longitude: params[:longitude])
      waypoint = Waypoint.lookup(params[:waypoint], waypoint_coordinate)
      index = params[:index].to_i
      airway[index - 1] = AirwaySegment.new(airway: airway, index: index, waypoint: waypoint, extra: params[:extra])
    end

    def self.output_airway(airway, columns)
      airway.map { |segment| AirwaySegmentIO.output(segment, columns) }.join("\n")
    end
  end
end
