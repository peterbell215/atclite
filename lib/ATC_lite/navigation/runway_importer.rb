# frozen_string_literal: true

module ATCLite
  module Navigation
    # Reads an FSBuild intersection file and stores the data.
    class RunwayImporter
      include NavigationDataImporter

      FIELDS = [
        [:name, /[0-3][0-9][A-Z]?/],
        [:length, /[0-9]+/],
        [:latitude, LONGLAT],
        [:longitude, LONGLAT],
        [:heading, /[0-3][0-9][0-9]/],
        [:ils, /#{FREQUENCY}|\-{3}/ ]
      ].freeze
      FIELD_SEPARATOR = '_'

      def self.match(string, line)
        parse(string, line)&.yield_self { |params| Runway.new(**params) }
      end
    end
  end
end