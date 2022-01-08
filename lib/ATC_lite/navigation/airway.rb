# frozen_string_literal: true


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

    # output
    def self.all
      @airways.values.lazy
    end

    # Has an airways text file been loaded into memory?
    def self.loaded?
      !@airways.empty?
    end

    # Constructor for the Airway object
    # rubocop: disable Lint/MissingSuper
    def initialize(name)
      @name = name
    end
    # rubocop: enable Lint/MissingSuper
  end
end
