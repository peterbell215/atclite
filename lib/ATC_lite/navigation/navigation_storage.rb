# frozen_string_literal: true

require 'latitude'

module ATCLite
  module Navigation

    module NavigationStorage
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def add(radio_navigation_aid)
          @data ||= Hash.new { |hash, key| hash[key] = [] }
          @data[radio_navigation_aid.name].push(radio_navigation_aid)
        end

        def lookup(name, near_to)
          @data[name].min_by { |aid| aid.distance_to(near_to) }
        end
      end
    end
  end
end
