# frozen_string_literal: true

module ATCLite
  module Navigation
    # Reads a Euroscope Sector File and stores the data.
    class NavigationDataImport
      LONGLAT = /[+-]?[0-9]+\.[0-9]+/
      NAVTYPE = /VOR|NDB/
      FREQUENCY = /[1-9][0-9]{2,3}\.[0-9]{2,3}/
      FIELDS = [
        [ :name , /^[0-9A-Z]{1,3}/ ],
        [ :fullname, /[_A-Z]+/ ],
        [ :latitude, LONGLAT ],
        [ :longitude, LONGLAT ],
        [ :navtype, NAVTYPE ],
        [ :frequency, FREQUENCY],
        [ :region, /[A-Z]{3}/]
      ].freeze

      def self.parse_navs_file(name = 'data/navs.txt')
        File.readlines(name, chomp: true).each_with_index do |line, line_number|
          line.strip!

          next if line[0] == ';' || line.empty?

          radio_navigation_aid = NavigationDataImport.navs_line(line, line_number)

          next unless radio_navigation_aid

          RadioNavigationAid.add_aid(radio_navigation_aid)
        end
      end

      def self.navs_line(line, line_number)
        fields = FIELDS.each

        params =
          line.split.inject({}) do |params, element|
            field, regexp = fields.next

            if regexp =~ element
              params&.store(field, element)
            else
              $stderr.puts(line)
              $stderr.puts("#{' ' * line.index(element)}^Mis-formed #{field} on line #{line_number}")
              params = nil
            end
            params
          end

        params && RadioNavigationAid.new(**params)
      end
    end
  end
end
