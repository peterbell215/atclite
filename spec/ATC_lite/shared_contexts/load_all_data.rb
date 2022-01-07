# frozen_string_literal: true

RSpec.shared_context 'load navigation data', shared_context: :metadata do
  # rubocop: disable RSpec/BeforeAfterAll the data is read in read-only so no danger of state
  #                                       leakage.  Its a large data file so reading once rather
  #                                       than for every test is better.
  before(:all) do
    Navigation::RadioNavigationAidImporter.parse_navs_file('data/navs-uk.txt')
    Navigation::IntersectionImporter.parse_ints_file('data/ints-uk.txt')
    Navigation::AirwayImporter.parse_awys_file('data/awys-uk.txt')
    Navigation::AirportImporter.parse_apts_file('data/apts-uk.txt')
  end

  after(:all) do
    Navigation::Airway.clear_data
    Navigation::RadioNavigationAid.clear_data
    Navigation::Intersection.clear_data
    Navigation::Airport.clear_data
  end
  # rubocop: enable RSpec/BeforeAfterAll
end
