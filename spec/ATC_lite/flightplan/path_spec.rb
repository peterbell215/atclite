# frozen_string_literal: true

require 'rspec'

RSpec.describe ATCLite::Flightplan::Path do
  # rubocop: disable RSpec/BeforeAfterAll the data is read in read-only so no danger of state
  #                                       leakage.  Its a large data file so reading once rather
  #                                       than for every test is better.
  before(:all) do
    ATCLite::Navigation::RadioNavigationAidImporter.parse_navs_file
    ATCLite::Navigation::IntersectionImporter.parse_ints_file
    ATCLite::Navigation::AirwayImporter.parse_awys_file
    ATCLite::Navigation::AirportImporter.parse_apts_file
  end

  after(:all) do
    ATCLite::Navigation::Airway.clear_data
    ATCLite::Navigation::RadioNavigationAid.clear_data
    ATCLite::Navigation::Intersection.clear_data
    ATCLite::Navigation::Airport.clear_data
  end
  # rubocop: enable RSpec/BeforeAfterAll

  describe 'enroute processing' do
    subject(:path) { described_class.new(departure_airport: 'EGLL', enroute: 'UMLAT T418 WELIN T420 TNT UN57 POL UN601 INPIP') }

    specify do
      puts path
      expect(path.size).to eq 23
    end
  end
end