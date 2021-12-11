require 'rspec'

RSpec.describe ATCLite::ATCScreen do
  subject(:atc_screen) { ATCLite::ATCScreen.instance }

  describe '#map_x' do
    specify { expect(atc_screen.map_x(atc_screen.centre_x)).to eq(Window.width / 2) }
  end

  describe '#map_y' do
    specify { expect(atc_screen.map_y(atc_screen.centre_y)).to eq(Window.height / 2) }
  end
end
