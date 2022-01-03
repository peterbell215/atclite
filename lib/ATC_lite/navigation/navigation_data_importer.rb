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
          File.foreach(name, chomp: true).each_with_index do |line, line_number|
            line.strip!

            next if line[0] == ';' || line.empty?

            params = parse(line, line_number)

            next unless params

            nav_class.add(nav_class.new(**params))
          rescue AltitudeParameterError => e
            issue_warning(e.altitude_string, 'Altitude', line_number, line)
            next
          rescue StandardError
            warn("Standard error caught in #{line} on line #{line_number}")
            raise
          end
        end

        # Given a description of the structure of the line in the class constant FIELDS, parse the data and
        # store in a hash that can be passed to the class constructor.
        # rubocop: disable Metrics/MethodLength  Arguable that pushing anything into a separate private method would
        #                                        make the code more readable.
        def parse(string, line_number)
          index = 0
          index_limit = self::FIELDS.size - 1

          string.split(self::FIELD_SEPARATOR).inject({}) do |params, element|
            field, regexp_or_subclass = self::FIELDS[index]
            index += 1 if index < index_limit

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

        def output(record, column_widths = nil)
          column_widths_iterator = column_widths_iterator_factory(column_widths)

          self::FIELDS.map do |field, field_format, missing_value|
            if field_format.is_a?(Array)
              output_subrecords(record, field, field_format[0], column_widths_iterator)
            else
              output_field(field, record, missing_value, column_widths_iterator)
            end
          end.join(self::FIELD_SEPARATOR).strip
        end

        private

        # Given an array, constructs an iterator that returns the array until we have run out of elements,
        # and thereafter returns 0.
        def column_widths_iterator_factory(column_widths)
          constant_zero = (0..).lazy.map { 1 }
          column_widths ? (column_widths.each + constant_zero).each : constant_zero
        end

        def output_field(field, record, missing_value, column_widths_iterator)
          field_value = record.send(field)
          s = if field_value
                field_value.respond_to?(:name) ? field_value.name : field_value.to_s
              else
                missing_value
              end

          pad_field(s, column_widths_iterator)
        end

        def output_subrecords(record, field, importer_class, column_widths_iterator)
          record.send(field).map do |sub_record|
            if importer_class.respond_to?(:output)
              importer_class.output(sub_record)
            else
              pad_field(sub_record.to_s, column_widths_iterator)
            end
          end.join(self::FIELD_SEPARATOR)
        end

        def pad_field(string, column_widths_iterator)
          string.ljust(column_widths_iterator.next - 1, self::FIELD_SEPARATOR)
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
