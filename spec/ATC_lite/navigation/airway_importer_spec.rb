# frozen_string_literal: true

require 'rspec'

RSpec.describe ATCLite::Navigation::AirwayImporter do
  describe '::parse_awys_file' do
    subject(:l603) { ATCLite::Navigation::Airway.lookup('L603') }

    # rubocop: disable RSpec/BeforeAfterAll the data is read in read-only so no danger of state
    #                                       leakage.  Its a large data file so reading once rather
    #                                       than for every test is better.
    before(:all) do
      ATCLite::Navigation::RadioNavigationAidImporter.parse_navs_file
      ATCLite::Navigation::IntersectionImporter.parse_ints_file
      described_class.parse_awys_file
    end

    after(:all) do
      ATCLite::Navigation::Airway.clear_data
      ATCLite::Navigation::RadioNavigationAid.clear_data
      ATCLite::Navigation::Intersection.clear_data
    end
    # rubocop: enable RSpec/BeforeAfterAll

    let(:pj) { ATCLite::Navigation::RadioNavigationAid.lookup('PJ') }
    let(:belox) { ATCLite::Navigation::Intersection.lookup('BELOX') }

    specify { expect(l603.size).to eq 48 }
    specify { expect(l603[0].waypoint).to equal pj }
    specify { expect(l603[5].waypoint).to equal belox }
  end
end
