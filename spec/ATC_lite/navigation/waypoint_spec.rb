# frozen_string_literal: true

require 'rspec'

RSpec.describe ATCLite::Navigation::Waypoint do
  describe '#initialize' do
    subject(:waypoint) { described_class.new(name: 'WAYPO', latitude: '51.4700° N', longitude: '0.4543° W', region: 'EUR') }

    specify { expect(waypoint.name).to eq('WAYPO') }
    specify { expect(waypoint.latitude).to eq(51.47) }
    specify { expect(waypoint.longitude).to eq(-0.4543) }
  end

  describe '#==' do
    subject(:waypoint1) { ATCLite::Navigation::Waypoint.new(name: 'UMLAT', longitude: -0.694256, latitude: 51.672139, region: 'EUR') }

    let(:airway) { ATCLite::Navigation::AirwaySegment.new(airway: nil, index: 1, waypoint: waypoint2, extra: nil) }
    let(:waypoint2) { ATCLite::Navigation::Waypoint.new(name: 'UMLAT', longitude: -0.694256, latitude: 51.672139, region: 'EUR')}

    specify { expect(waypoint1 == airway).to be_truthy }
  end
end
