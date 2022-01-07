require 'rspec'

RSpec.describe ATCScreen do
  subject(:atc_screen) { ATCScreen.instance }

  describe '#map_x' do
    specify { expect(atc_screen.map_x(atc_screen.centre_x)).to eq(Window.width / 2) }
    specify { expect(atc_screen.map_x(atc_screen.centre_x - 1)).to eq(Window.width / 2 - atc_screen.scale) }
  end

  describe '#map_y' do
    specify { expect(atc_screen.map_y(atc_screen.centre_y)).to eq(Window.height / 2) }
    specify { expect(atc_screen.map_y(atc_screen.centre_y - 1)).to eq(Window.height / 2 - atc_screen.scale) }
  end
end
