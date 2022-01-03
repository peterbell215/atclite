# frozen_string_literal: true

require 'rspec'

RSpec.describe ATCLite::Navigation::AirwaySegmentIO do
  describe '::parse' do
    subject(:airway_segment_hash) { described_class.parse('L746    0014 DASIS   38.908611 44.208056  L   B', 1) }

    specify { expect(airway_segment_hash[:airway]).to eq 'L746' }
    specify { expect(airway_segment_hash[:index]).to eq '0014' }
    specify { expect(airway_segment_hash[:waypoint]).to eq 'DASIS' }
    specify { expect(airway_segment_hash[:latitude]).to eq '38.908611' }
    specify { expect(airway_segment_hash[:longitude]).to eq '44.208056' }
    specify { expect(airway_segment_hash[:extra].size).to eq 2 }
    specify { expect(airway_segment_hash[:extra][0]).to eq 'L' }
    specify { expect(airway_segment_hash[:extra][1]).to eq 'B' }
  end

  describe '::output' do
    # rubocop: disable RSpec/BeforeAfterAll the data is read in read-only so no danger of state
    #                                       leakage.  Its a large data file so reading once rather
    #                                       than for every test is better.
    before(:all) do
      ATCLite::Navigation::RadioNavigationAidImporter.parse_navs_file
      ATCLite::Navigation::IntersectionImporter.parse_ints_file
    end

    after(:all) do
      ATCLite::Navigation::RadioNavigationAid.clear_data
      ATCLite::Navigation::Intersection.clear_data
    end
    # rubocop: enable RSpec/BeforeAfterAll

    subject(:segment) do
      ATCLite::Navigation::AirwaySegment.new(airway: airway, index: 14, waypoint: waypoint, extra: %w[L B])
    end

    let(:airway) { ATCLite::Navigation::Airway.find_or_create('L746') }
    let(:waypoint) { ATCLite::Navigation::Intersection.lookup('DASIS') }

    it 'creates an appropriate string' do
      expect(described_class.output(segment, [8, 5, 8, 10, 10, 0])).to eq 'L746    14   DASIS   38.908611 44.208056 L B'
    end
  end
end