# frozen_string_literal: true

require 'rspec'

RSpec.describe Flightplan::Path do
  # rubocop: disable RSpec/BeforeAfterAll the data is read in read-only so no danger of state
  #                                       leakage.  Its a large data file so reading once rather
  #                                       than for every test is better.
  before(:all) do
    Navigation::RadioNavigationAidIO.parse_navs_file('data/navs-uk.txt')
    Navigation::IntersectionIO.parse_ints_file('data/ints-uk.txt')
    Navigation::AirwayIO.parse_awys_file('data/awys-uk.txt')
    Navigation::AirportIO.parse_apts_file('data/apts-uk.txt')
  end

  after(:all) do
    Navigation::Airway.clear_data
    Navigation::RadioNavigationAid.clear_data
    Navigation::Intersection.clear_data
    Navigation::Airport.clear_data
  end
  # rubocop: enable RSpec/BeforeAfterAll

  describe 'enroute processing' do
    shared_examples_for 'processing a path string' do |path_string|
      subject(:path) { described_class.new(string: path_string, close_to: egll) }

      let(:correct_path) { 'UMLAT WOBUN WELIN AKUPA TIMPO ELVOS TNT POL NELSA RIBEL ERGAB SHAPP ABEVI INPIP' }
      let(:egll) { Navigation::Airport.lookup('EGLL') }

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