# frozen_string_literal: true

module ATCLite
  module Navigation
    # Airway describes the waypoints on an airway.
    class Airway < Array
      attr_reader :name

      @airways = {}

      def self.find_or_create(name)
        @airways[name] ||= Airway.new(name)
      end

      def self.lookup(name)
        @airways[name]
      end

      def self.clear_data
        @airways = {}
        GC.start
      end

      # Constructor for the Airway object
      def initialize(name)
        @name = name
      end
    end
  end
end
