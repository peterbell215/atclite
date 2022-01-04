# frozen_string_literal: true

require 'rspec'

RSpec.describe ATCLite::Flightplan::Path do
  # rubocop: disable RSpec/BeforeAfterAll the data is read in read-only so no danger of state
  #                                       leakage.  Its a large data file so reading once rather
  #                                       than for every test is better.
  before(:all) do
    ATCLite::Navigation::RadioNavigationAidImporter.parse_navs_file('data/navs-uk.txt')
    ATCLite::Navigation::IntersectionImporter.parse_ints_file('data/ints-uk.txt')
    ATCLite::Navigation::AirwayImporter.parse_awys_file('data/awys-uk.txt')
    ATCLite::Navigation::AirportImporter.parse_apts_file('data/apts-uk.txt')
  end

  after(:all) do
    ATCLite::Navigation::Airway.clear_data
    ATCLite::Navigation::RadioNavigationAid.clear_data
    ATCLite::Navigation::Intersection.clear_data
    ATCLite::Navigation::Airport.clear_data
  end
  # rubocop: enable RSpec/BeforeAfterAll

  describe 'enroute processing' do
    shared_examples_for 'processing a path string' do |path_string|
      subject(:path) { described_class.new(departure_airport: 'EGLL', enroute: path_string) }

      let(:correct_path) { 'UMLAT WOBUN WELIN AKUPA TIMPO ELVOS TNT POL NELSA RIBEL ERGAB SHAPP ABEVI INPIP' }

      specify { expect(path.map(&:name).join(' ')).to eq correct_path }
    end

    context 'when the path is along airways' do
      it_behaves_like 'processing a path string', 'UMLAT T418 WELIN T420 TNT UN57 POL UN601 INPIP'
    end

    context 'when the path includes a direct routing' do
      it_behaves_like 'processing a path string', 'UMLAT T418 WELIN T420 TNT POL UN601 INPIP'
    end

    context 'when the path is purely a direct routing' do
      it_behaves_like 'processing a path string', 'UMLAT WOBUN WELIN AKUPA TIMPO ELVOS TNT POL NELSA RIBEL ERGAB SHAPP ABEVI INPIP'
    end
  end
end