require 'rspec'

RSpec.describe ATCLite::Aircraft do
  describe '#update' do
    shared_examples_for 'updated position based on heading' do |heading, x, y|
      before do
        aircraft.heading = heading
        aircraft.update_position
      end

      it "calculates the updated position for #{heading}" do
        expect(aircraft.x).to be_within(0.001).of(x)
        expect(aircraft.y).to be_within(0.001).of(y)
      end
    end

    subject(:aircraft) { ATCLite::Aircraft.new(speed: 3600) }
    it_behaves_like 'updated position based on heading', 0.0, 0.0, -1.0
    it_behaves_like 'updated position based on heading', 90.0, 1.0, 0.0
    it_behaves_like 'updated position based on heading', 180.0, 0.0, 1.0
    it_behaves_like 'updated position based on heading', 270.0, -1.0, 0.0
  end
end
