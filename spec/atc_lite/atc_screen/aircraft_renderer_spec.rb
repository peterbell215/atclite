# frozen_string_literal: true

require 'rspec'

RSpec.describe AtcScreen::AircraftRenderer do
  let(:atc_screen) { AtcScreen.instance }
  let(:radar_screen) { instance_double(Gtk::DrawingArea, allocated_height: 400, allocated_width: 300) }

  before do
    Aircraft::AircraftPerformance.load_file
    allow(atc_screen).to receive(:radar_screen).and_return(radar_screen)
  end

  describe '#draw' do
    subject(:aircraft_renderer) { AircraftRenderer.new(aircraft) }

    let(:aircraft) do
      Aircraft::Aircraft.build(callsign: 'BA001', type: 'A19N',
                               speed: 3600.0, heading: 90.0.degrees, altitude: 330.fl, position: atc_screen.centre)
    end
    let(:cr) { instance_double(Cairo::Context) }
    let(:layout) { instance_double(Pango::Layout, font_description: instance_double(Pango::FontDescription)) }

    before do
      allow(cr).to receive_messages(set_source_rgb: nil, set_line_width: nil, rectangle: nil, stroke: nil, move_to: nil)

      allow(cr).to receive(:create_pango_layout).and_return(layout)
      allow(cr).to receive(:show_pango_layout)
      allow(layout).to receive_messages(:text= => true, :font_description= => true)
    end

    describe 'draws a box on the radar screen' do
      before do
        atc_screen.scale = 10
        aircraft_renderer.draw(cr)
      end

      specify { expect(cr).to have_received(:rectangle).with(145.0, 195.0, 10, 10) }
      specify { expect(cr).to have_received(:move_to).with(165.0, 190.0) }
      specify { expect(layout).to have_received(:text=).with('BA001') }
    end

    describe 'builds a history of aircraft positions' do
      it 'has one element in the history on initialization' do
        expect(aircraft_renderer.position_history.size).to eq 0
        aircraft_renderer.draw(cr)
        expect(aircraft_renderer.position_history.size).to eq 1
        expect(aircraft_renderer.position_history.first).to eq atc_screen.centre
      end

      it 'has three elements in the history after three updates' do
        move_aircraft(2)
        expect(aircraft_renderer.position_history.size).to eq 3
        expect(aircraft_renderer.position_history.first).to eq atc_screen.centre
        expect(aircraft_renderer.position_history.last).to eq aircraft.position
      end

      it 'drops positions from the history once four updates exist' do
        move_aircraft(6)
        expect(aircraft_renderer.position_history.size).to eq 4
        expect(aircraft_renderer.position_history.first).not_to eq atc_screen.centre
        expect(aircraft_renderer.position_history.last).to eq aircraft.position
      end

      def move_aircraft(iterations)
        aircraft_renderer.draw(cr)
        iterations.times do
          12.times { aircraft.update_position }
          aircraft_renderer.draw(cr)
        end
      end
    end
  end
end
