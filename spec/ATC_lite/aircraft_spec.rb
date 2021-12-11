require 'rspec'

RSpec.describe ATCLite::Aircraft do
  describe '#update_position' do
    shared_examples_for 'updated position based on heading' do |heading, x, y|
      subject(:aircraft) { ATCLite::Aircraft.new(speed: 3600, heading: heading) }

      it "calculates the updated position for #{heading}" do
        aircraft.update_position

        expect(aircraft.x).to be_within(0.001).of(x)
        expect(aircraft.y).to be_within(0.001).of(y)
      end
    end

    it_behaves_like 'updated position based on heading', 0.0, 0.0, -1.0
    it_behaves_like 'updated position based on heading', 90.0, 1.0, 0.0
    it_behaves_like 'updated position based on heading', 180.0, 0.0, 1.0
    it_behaves_like 'updated position based on heading', 270.0, -1.0, 0.0
  end

  describe '#update_heading' do
    shared_examples_for 'updated heading' do |current_heading, target_heading, new_heading|
      subject(:aircraft) { ATCLite::Aircraft.new(heading: current_heading) }

      it "calculates the updated heading when turning from #{current_heading} to #{target_heading}" do
        aircraft.target_heading = target_heading
        aircraft.update_heading
        expect(aircraft.heading).to eq(new_heading)
      end
    end

    subject(:aircraft) { ATCLite::Aircraft.new }

    it_behaves_like 'updated heading', 270, 280, 272
    it_behaves_like 'updated heading', 270, 271, 271
    it_behaves_like 'updated heading', 270, 260, 268
    it_behaves_like 'updated heading', 270, 269, 269
    it_behaves_like 'updated heading', 359, 10, 1
    it_behaves_like 'updated heading', 1, 350, 359
  end
end
