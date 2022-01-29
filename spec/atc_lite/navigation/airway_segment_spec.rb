# frozen_string_literal: true

require 'rspec'

RSpec.describe Navigation::AirwaySegment do
  subject(:airway_segment) { Navigation::AirwaySegment.new(airway: airway, index: 1, waypoint: waypoint2, extra: nil) }

  let(:airway) { Navigation::Airway.new('L603') }

  let(:waypoint1) { Navigation::Waypoint.new(name: 'UMLAT', longitude: -0.694256, latitude: 51.672139, region: 'EUR') }
  let(:waypoint2) { Navigation::Waypoint.new(name: 'UMLAT', longitude: -0.694256, latitude: 51.672139, region: 'EUR') }

  describe '#initialize' do
    specify { expect(airway_segment.waypoint.name).to eq('UMLAT') }
    specify { expect(airway_segment.waypoint.latitude).to eq(waypoint2.latitude) }
    specify { expect(airway_segment.waypoint.longitude).to eq(waypoint2.longitude) }
  end

  describe '#==' do
    specify { expect(airway_segment == waypoint2).to be_truthy }
  end
end