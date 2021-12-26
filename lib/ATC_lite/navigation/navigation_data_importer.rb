# frozen_string_literal: true

module ATCLite
  module Navigation
    # Provides generic functionality to read FSBuild data files.
    module NavigationDataImporter
      LONGLAT = /[+-]?[0-9]+\.[0-9]+/
      FREQUENCY = /[1-9][0-9]{2,3}\.[0-9]{2,3}/

      def self.included(base)
        base.extend(ClassMethods)
      end

      # Add class methods to be used by the various Waypoint derived classes.
      module ClassMethods
        # Parse an FSBuild data file and store the results in the relevant class.
        def parse_file(name, nav_class)
          File.readlines(name, chomp: true).each_with_index do |line, line_number|
            line.strip!

            next if line[0] == ';' || line.empty?

            params = parse(line, line_number)

            next unless params

            nav_class.add(nav_class.new(**params))
          end
        end

        # Given a description of the structure of the line in the class constant FIELDS, parse the data and
        # store in a hash that can be passed to the class constructor.
        # rubocop: disable Metrics/MethodLength  Arguable that pushing anything into a separate private method would
        #                                        make the code more readable.
        def parse(string, line_number)
          fields_iterator = fields_enumerator

          string.split(self::FIELD_SEPARATOR).inject({}) do |params, element|
            field, regexp_or_subclass = fields_iterator.next
            result = parse_field(regexp_or_subclass, element, line_number)

            if result.nil?
              issue_warning(element, field, line_number, string)
              break nil
            end

            break nil unless params # We have stopped storing result due to a previous parse error in the line.

            store_result(params, regexp_or_subclass.is_a?(Array), field, result)
          end
        end
        # rubocop: enable Metrics/MethodLength

        private

        def fields_enumerator
          Enumerator.new do |y|
            index = 0
            limit = self::FIELDS.size - 1
            loop do
              y << self::FIELDS[index]
              index += 1 if index < limit
            end
          end
        end

        def parse_field(regexp_or_subclass, element, line)
          case regexp_or_subclass
          when Regexp then regexp_or_subclass =~ element ? element : nil
          when Array then parse_field(regexp_or_subclass[0], element, line)
          else regexp_or_subclass.match(element, line)
          end
        end

        def issue_warning(element, field, line_number, string)
          warn(string)
          warn("#{' ' * string.index(element)}^Mis-formed #{field} on line #{line_number}")
        end

        def store_result(params, store_as_array, field, value)
          if store_as_array
            params[field] ||= []
            params[field].push(value)
          else
            params[field] = value
          end
          params
        end
      end
    end
  end
end
