# frozen_string_literal: true

require 'rspec'

RSpec.describe Aircraft::Aircraft do
  before { Aircraft::AircraftPerformance.load_file }

  describe '#initialize' do
    subject(:aircraft) { Aircraft::Aircraft.new(callsign: 'BA001', type: 'A19N') }

    specify { expect(aircraft.callsign).to eq 'BA001' }
    specify { expect(aircraft.type).to eq 'A19N' }
  end

  describe '#build' do
    subject(:aircraft) do
      Aircraft::Aircraft.build(callsign: 'BA001', type: 'A19N', altitude: 3000.ft, position: position)
    end

    let(:position) { Coordinate.new(latitude: 51.0, longitude: -0.2) }

    specify { expect(aircraft.callsign).to eq 'BA001' }
    specify { expect(aircraft.type).to eq 'A19N' }
    specify { expect(aircraft.altitude).to eq 3000.ft }
    specify { expect(aircraft.position).to eq Coordinate.new(latitude: 51.0, longitude: -0.2) }
  end

  describe '#file_flightplan' do
    subject(:aircraft) do
      Aircraft::Aircraft.file_flightplan(callsign: 'BA001', type: 'A19N', flightplan: flightplan)
    end

    include_context 'load navigation data'

    let(:flightplan) do
      Flightplan::Flightplan.new(departure_airport: 'EGLL',
                                 enroute: 'UMLAT T418 WELIN T420 TNT UN57 POL UN601 INPIP')
    end
    let(:egll) { Navigation::Airport.lookup('EGLL') }
    let(:umlat) { Navigation::Intersection.lookup('UMLAT', egll) }
    let(:wobun) { Navigation::Intersection.lookup('WOBUN', egll) }

    specify { expect(aircraft.callsign).to eq 'BA001' }
    specify { expect(aircraft.type).to eq 'A19N' }
    specify { expect(aircraft.position).to eq egll }
    specify { expect(aircraft.position).not_to be_equal egll }
    specify { expect(aircraft.heading).to eq egll.initial_heading_to(umlat) }
    specify { expect(aircraft.altitude).to eq egll.altitude }
  end

  describe '#update_position' do
    shared_examples_for 'updated position based on heading' do |heading, latitude, longitude|
      subject(:aircraft) do
        Aircraft::Aircraft.build(callsign: 'BA001', type: 'A19N',
                                 speed: 3600.0, heading: heading, altitude: 330.fl, position: position)
      end

      let(:position) { Coordinate.new(latitude: 0.0, longitude: 0.0) }
      let(:arc_minute) { 1.0 / 60.0 }

      it "calculates the updated position for #{heading}" do
        aircraft.update_position

        expect(aircraft.position.latitude.degrees).to be_within(0.001).of(latitude * arc_minute)
        expect(aircraft.position.longitude.degrees).to be_within(0.001).of(longitude * arc_minute)
      end
    end

    it_behaves_like 'updated position based on heading', 0.0.degrees, 1.0, 0.0
    it_behaves_like 'updated position based on heading', 90.0.degrees, 0.0, 1.0
    it_behaves_like 'updated position based on heading', 180.0.degrees, -1.0, 0.0
    it_behaves_like 'updated position based on heading', 270.0.degrees, 0.0, -1.0
  end

  describe '#update_heading' do
    shared_examples_for 'updated heading' do |current_heading, target_heading, new_heading|
      subject(:aircraft) do
        Aircraft::Aircraft.build(callsign: 'BA001', type: 'A19N',
                                 speed: 3600.0, heading: current_heading, altitude: 330.fl, position: position)
      end

      let(:position) { Coordinate.new(latitude: 0.0, longitude: 0.0) }

      it "calculates the updated heading when turning from #{current_heading} to #{target_heading}" do
        aircraft.target_heading = target_heading.degrees
        aircraft.update_heading
        expect(aircraft.heading).to eq(new_heading.degrees)
      end
    end

    it_behaves_like 'updated heading', 270, 280, 272
    it_behaves_like 'updated heading', 270, 271, 271
    it_behaves_like 'updated heading', 270, 260, 268
    it_behaves_like 'updated heading', 270, 269, 269
    it_behaves_like 'updated heading', 359, 10, 1
    it_behaves_like 'updated heading', 1, 350, 359
  end

end
