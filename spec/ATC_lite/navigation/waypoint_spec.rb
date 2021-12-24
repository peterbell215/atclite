# frozen_string_literal: true

require 'rspec'

RSpec.describe ATCLite::Navigation::Waypoint do
  describe '#initialize' do
    subject(:waypoint) { described_class.new(name: 'WAYPO', latitude: '51.4700° N', longitude: '0.4543° W', region: 'EUR') }

    specify { expect(waypoint.name).to eq('WAYPO') }
    specify { expect(waypoint.latitude).to eq(51.47) }
    specify { expect(waypoint.longitude).to eq(-0.4543) }
  end
end