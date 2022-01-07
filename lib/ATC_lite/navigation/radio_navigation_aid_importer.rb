# frozen_string_literal: true

module Navigation
  # Reads an FSBuild Radio Navigation Aids File and stores the data.
  class RadioNavigationAidImporter
    include NavigationDataImporter

    NAVTYPE = /VOR|NDB/
    FIELDS = [
      [:name, /^[0-9A-Z]{1,3}/],
      [:fullname, /[_A-Z]+/],
      [:latitude, LONGLAT],
      [:longitude, LONGLAT],
      [:navtype, NAVTYPE],
      [:frequency, FREQUENCY],
      [:region, /[A-Z]{3}/]
    ].freeze
    FIELD_SEPARATOR = ' '

    def self.parse_navs_file(name = 'data/navs.txt')
      self.parse_file(name, RadioNavigationAid)
    end
  end
end
