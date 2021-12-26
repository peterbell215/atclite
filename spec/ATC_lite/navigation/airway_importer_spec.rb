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

    let(:pj) { ATCLite::Navigation::RadioNavigationAid.lookup(name: 'PJ') }
    let(:belox) { ATCLite::Navigation::Intersection.lookup(name: 'BELOX') }

    specify { expect(l603.size).to eq 48 }
    specify { expect(l603[0]).to equal pj }
    specify { expect(l603[5]).to equal belox }
  end

  describe '::parse' do
    subject(:waypoint) do
      described_class.parse('L603    0003 LISBO               54.525000     -6.090028     B   F', 1)
    end

    specify { expect(waypoint[:name]).to eq 'L603' }
    specify { expect(waypoint[:index]).to eq '0003' }
    specify { expect(waypoint[:waypoint]).to eq 'LISBO' }
    specify { expect(waypoint[:latitude]).to eq '54.525000' }
    specify { expect(waypoint[:longitude]).to eq '-6.090028' }
    specify { expect(waypoint[:extra][0]).to eq 'B' }
    specify { expect(waypoint[:extra][1]).to eq 'F' }
  end
end
