# frozen_string_literal: true

require 'rspec'

RSpec.describe Navigation::AirwayIO do
  describe '::parse_awys_file' do
    subject(:l70) { Navigation::Airway.lookup('L70') }

    # rubocop: disable RSpec/BeforeAfterAll the data is read in read-only so no danger of state
    #                                       leakage.  Its a large data file so reading once rather
    #                                       than for every test is better.
    before(:all) do
      Navigation::RadioNavigationAidIO.parse_navs_file('data/navs-uk.txt')
      Navigation::IntersectionIO.parse_ints_file('data/ints-uk.txt')
      described_class.parse_awys_file('data/awys-uk.txt')
    end

    after(:all) do
      Navigation::Airway.clear_data
      Navigation::RadioNavigationAid.clear_data
      Navigation::Intersection.clear_data
    end
    # rubocop: enable RSpec/BeforeAfterAll

    let(:bagso) { Navigation::Intersection.lookup('BAGSO') }
    let(:gigto) { Navigation::Intersection.lookup('GIGTO') }

    specify { expect(l70.size).to eq 12 }
    specify { expect(l70[0].waypoint).to equal bagso }
    specify { expect(l70[5].waypoint).to equal gigto }
  end
end
