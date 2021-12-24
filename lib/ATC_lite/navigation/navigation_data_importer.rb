# frozen_string_literal: true

module ATCLite
  module Navigation
    # Reads a Euroscope Sector File and stores the data.
    module NavigationDataImporter
      LONGLAT = /[+-]?[0-9]+\.[0-9]+/
      FREQUENCY = /[1-9][0-9]{2,3}\.[0-9]{2,3}/

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def parse_file(name, nav_class)
          File.readlines(name, chomp: true).each_with_index do |line, line_number|
            line.strip!

            next if line[0] == ';' || line.empty?

            params = navs_line(line, line_number)

            next unless params

            nav_class.add(nav_class.new(**params))
          end
        end

        def navs_line(line, line_number)
          fields_iterator = self::FIELDS.each

          line.split.inject({}) do |params, element|
            field, regexp = fields_iterator.next

            if regexp =~ element
              params&.store(field, element)
            else
              $stderr.puts(line)
              $stderr.puts("#{' ' * line.index(element)}^Mis-formed #{field} on line #{line_number}")
              params = nil
            end
            params
          end
        end
      end
    end
  end
end
