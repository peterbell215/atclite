require 'rspec'

RSpec.describe ATCScreen do
  subject(:atc_screen) { ATCScreen.instance }

  before do
    allow(atc_screen).to receive(:radar_screen).and_return(radar_screen)
  end

  let(:radar_screen) { instance_double(Gtk::DrawingArea, allocated_height: 400, allocated_width: 300) }

  let(:north) { atc_screen.centre.new_position(heading: 0.0.degrees, distance: 1.0) }
  let(:south) { atc_screen.centre.new_position(heading: 180.0.degrees, distance: 1.0) }
  let(:west) { atc_screen.centre.new_position(heading: 270.0.degrees, distance: 1.0) }
  let(:east) { atc_screen.centre.new_position(heading: 90.0.degrees, distance: 1.0) }

  describe '#map' do
    shared_examples 'for compass point' do |compass_heading, expected_x, expected_y|
      let(:compass_position) { self.send(compass_heading) }

      specify { expect(atc_screen.map(compass_position).first).to be_within(0.05).of(expected_x) }
      specify { expect(atc_screen.map(compass_position).second).to be_within(0.05).of(expected_y) }
    end

    it_behaves_like 'for compass point', :north, 300.0 * 0.5, 400.0 * 0.5 - 20
    it_behaves_like 'for compass point', :south, 300.0 * 0.5, 400.0 * 0.5 + 20
    it_behaves_like 'for compass point', :west, 300.0 * 0.5 - 20, 400.0 * 0.5
    it_behaves_like 'for compass point', :east, 300.0 * 0.5 + 20, 400.0 * 0.5
  end
end
