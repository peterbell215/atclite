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
end