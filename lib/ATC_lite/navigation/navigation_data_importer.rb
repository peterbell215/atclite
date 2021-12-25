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
          fields_iterator = self::FIELDS.each

          string.split(self::FIELD_SEPARATOR).inject({}) do |params, element|
            field, regexp_or_subclass = fields_iterator.next

            result = regexp_or_subclass.match(element)

            case result
            when MatchData then params&.store(field, element)
            when Waypoint then params && push_subclass(field, params, result)
            else
              issue_warning(element, field, line_number, string)
              params = nil
            end
            params
          end
        end
        # rubocop: enable Metrics/MethodLength

        private

        def issue_warning(element, field, line_number, string)
          warn(string)
          warn("#{' ' * string.index(element)}^Mis-formed #{field} on line #{line_number}")
        end

        def push_subclass(field, params, result)
          params[field] ||= []
          params[field].push(result)
        end
      end
    end
  end
end
