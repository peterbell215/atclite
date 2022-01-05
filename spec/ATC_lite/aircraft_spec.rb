# frozen_string_literal: true

require 'rspec'

RSpec.describe ATCLite::Aircraft do
  before { ATCLite::AircraftPerformance.load_file }

  describe '#update_position' do


    shared_examples_for 'updated position based on heading' do |heading, latitude, longitude|
      subject(:aircraft) { ATCLite::Aircraft.new(speed: 3600.0, heading: heading, altitude: 330.fl, position: position) }

      let(:position) { Coordinate.new(latitude: 0.0, longitude: 0.0) }
      let(:arc_minute) { 1.0/60.0 }

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
    subject(:aircraft) { ATCLite::Aircraft.new }

    shared_examples_for 'updated heading' do |current_heading, target_heading, new_heading|
      subject(:aircraft) do
        ATCLite::Aircraft.new(speed: 3600.0, heading: current_heading.degrees, altitude: 330.fl, position: position)
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

  describe '#update_altitude_and_phase' do
    context 'when it is in the cruise at the target altitude' do
      subject(:aircraft) { ATCLite::Aircraft.new(altitude: 370.fl) }

      before { aircraft.update_altitude_and_phase }

      specify { expect(aircraft.roc).to eq 0 }
      specify { expect(aircraft.phase).to eq :cruise }
    end

    context 'when it is flying level during the initial climb' do
      subject(:aircraft) { ATCLite::Aircraft.new(flightplan: nil, altitude: 5000) }

      before { aircraft.update_altitude_and_phase }

      specify { expect(aircraft.roc).to eq 0 }
      specify { expect(aircraft.phase).to eq :initial_climb }
    end

    context 'when it starts the climb' do
      before do
        aircraft.target_altitude = 5000
        aircraft.update_altitude_and_phase
      end

      specify { expect(aircraft.phase).to eq :initial_climb }
      specify { expect(aircraft.roc).to eq 2500 }
    end
  end
end
