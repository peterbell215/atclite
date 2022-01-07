# frozen_string_literal: true

require 'rspec'

RSpec.describe Flightplan::Flightplan do
  subject(:flightplan) { Flightplan::Flightplan.new(departure_airport: 'EGLL', enroute: enroute) }

  let(:enroute) { 'UMLAT T418 WELIN T420 TNT UN57 POL UN601 INPIP' }

  let(:egll) { Navigation::Airport.lookup('EGLL') }
  let(:umlat) { Navigation::Intersection.lookup('UMLAT', egll) }
  let(:wobun) { Navigation::Intersection.lookup('WOBUN', egll) }

  include_context 'load navigation data'

  describe '#desired_heading' do
    context 'when flying a path' do
      it 'gives the heading to the next waypoint' do
        expect(flightplan.desired_heading(egll)).to eq egll.initial_heading_to(umlat)
      end

      it 'moves to the next position' do
        expect(flightplan.desired_heading(umlat)).to eq umlat.initial_heading_to(wobun)
      end
    end

    context 'when flying a heading' do
      before { flightplan.fly_heading(180.degrees) }

      it 'returns the specified heading' do
        expect(flightplan.desired_heading(umlat)).to eq 180.degrees
      end
    end

    context 'when flying direct' do
      let(:tnt) { Navigation::RadioNavigationAid.lookup('TNT', egll) }

      it 'removes the previous waypoints and sets heading to the new waypoint' do
        flightplan.fly_direct(tnt)

        expect(flightplan.desired_heading(umlat)).to eq umlat.initial_heading_to(tnt)
        expect(flightplan.current).to eq tnt
      end

      it 'deals with a fly_heading instruction' do
        flightplan.fly_heading(180.degrees)
        flightplan.fly_direct(tnt)

        expect(flightplan.desired_heading(umlat)).to eq umlat.initial_heading_to(tnt)
        expect(flightplan.current).to eq tnt
      end
    end
  end
end
