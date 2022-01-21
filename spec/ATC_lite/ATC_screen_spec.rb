require 'rspec'

RSpec.describe ATCScreen do
  subject(:atc_screen) { ATCScreen.instance }

  before do
    allow(atc_screen).to receive(:radar_screen).and_return(radar_screen)
  end

  let(:radar_screen) { instance_double(Gtk::DrawingArea, allocated_height: 400, allocated_width: 300) }

  describe '#map_x' do
    specify { expect(atc_screen.map_x(0.0)).to eq(300 / 2) }
    specify { expect(atc_screen.map_x(-1.0)).to eq(300 / 2 - atc_screen.scale) }
  end

  describe '#map_y' do
    specify { expect(atc_screen.map_y(0.0)).to eq(400 / 2) }
    specify { expect(atc_screen.map_y(-1.0)).to eq(400 / 2 + atc_screen.scale) }
  end
end
