# frozen_string_literal: true

module Navigation
  # Reads an FSBuild intersection file and stores the data.
  class IntersectionIO
    include NavigationDataIO

    FIELDS = [
      [:name, /^[0-9A-Z]{1,5}/],
      [:alternate_name, /[0-9_A-Z]+/],
      [:latitude, LONGLAT],
      [:longitude, LONGLAT],
      [:region, /[A-Z]{3}/]
    ].freeze
    FIELD_SEPARATOR = ' '

    def self.parse_ints_file(name = 'data/ints.txt')
      self.parse_file(name, Intersection)
    end
  end
end
