# frozen_string_literal: true

require 'rspec'

RSpec.describe AtcScreen do
  subject(:atc_screen) { AtcScreen.instance }

  before do
    allow(atc_screen).to receive(:radar_screen).and_return(radar_screen)
    atc_screen.scale = 10
  end

  let(:radar_screen) { instance_double(Gtk::DrawingArea, allocated_height: 400, allocated_width: 300) }

  describe '#map' do
    let(:north) { [atc_screen.centre.new_position(heading: 0.0.degrees, distance: 1.0), 0.0, -atc_screen.scale] }
    let(:south) { [atc_screen.centre.new_position(heading: 180.0.degrees, distance: 1.0), 0.0, atc_screen.scale] }
    let(:west) { [atc_screen.centre.new_position(heading: 270.0.degrees, distance: 1.0), -atc_screen.scale, 0.0] }
    let(:east) { [atc_screen.centre.new_position(heading: 90.0.degrees, distance: 1.0), atc_screen.scale, 0.0] }

    shared_examples 'for compass point' do |compass_heading|
      it "correctly maps the point for #{compass_heading}" do
        position, delta_x, delta_y = self.send(compass_heading)
        screen_x, screen_y = atc_screen.map(position)

        expect(screen_x).to be_within(0.05).of(300.0 * 0.5 + delta_x)
        expect(screen_y).to be_within(0.05).of(400.0 * 0.5 + delta_y)
      end
    end

    it_behaves_like 'for compass point', :north
    it_behaves_like 'for compass point', :south
    it_behaves_like 'for compass point', :west
    it_behaves_like 'for compass point', :east
  end

  describe '#scale=' do

  end

  describe '#on_screen?' do
    it 'returns false for a point to the north to screen area' do

    end
  end
end
