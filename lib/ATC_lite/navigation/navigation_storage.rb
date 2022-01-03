# frozen_string_literal: true

require 'great-circle'

module ATCLite
  module Navigation

    module NavigationStorage
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def add(object)
          @data ||= Hash.new { |hash, key| hash[key] = [] }
          @data[object.name].push(object)
        end

        def lookup(name, near_to = nil)
          if near_to
            @data[name].min_by { |aid| aid.distance_to(near_to) }
          else
            raise AmbiguousReferenceError.new(name) if @data[name].size > 1

            @data[name].first
          end
        end

        # output
        def all
          @data.values.flatten.each
        end

        def loaded?
          @data.present?
        end

        # Allows complete wiping of the storage.  Important for RSpec tests, where loading the Intersections consumes
        # significant memory.
        def clear_data
          @data = nil
          GC.start
        end
      end
    end

    # If we look up a navigation reference using name only, and multiple references share the same name.
    class AmbiguousReferenceError < StandardError
      def initialize(name)
        super("Ambiguous reference to #{name}")
      end
    end
  end
end
