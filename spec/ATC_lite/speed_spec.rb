# frozen_string_literal: true

require 'rspec'

RSpec.describe ATCLite::Speed do
  describe '#initialize' do
    context 'with a tas' do
      subject(:airspeed) { described_class.new(100) }

      specify { expect(airspeed.knots).to eq 100 }
    end

    context 'with a mach' do
      subject(:airspeed) { described_class.new(mach: 0.8) }

      specify { expect(airspeed.mach).to eq 0.8 }
    end
  end

  describe 'conversions' do
    context 'when speed is set in knots' do
      subject(:airspeed) { described_class.new(airspeed_in_knots) }

      let(:airspeed_in_knots) { 650 * 0.5 }

      it 'returns the originally set airspeed in knots' do
        expect(airspeed.knots).to eq(airspeed_in_knots)
      end

      it 'ignores altitude and temperature parameters' do
        expect(airspeed.knots(altitude: 100.fl, temperature: -14.7)).to eq(airspeed_in_knots)

      end

      it 'returns the exact mach number if the altitude matches a table entry' do
        expect(airspeed.mach(altitude: 100.fl, temperature: -14.7)).to be_within(0.01).of(0.5)
      end

      it 'interpolates the mach number if it is between altitudes in the mach table' do
        mach_1_at_fl125 = (638 + 626) * 0.5
        expect(airspeed.mach(altitude: 125.fl, temperature: -14.7)).to be_within(0.01).of(325.0 / mach_1_at_fl125)
      end

      it 'uses the last entry in the mach table if the altitude is above that entry' do
        expect(airspeed.mach(altitude: 380.fl, temperature: -14.7)).to be_within(0.01).of(325.0 / 574.0)
      end
    end

    context 'when the speed is set in mach' do
      subject(:airspeed) { described_class.new(mach: 0.5) }

      it 'returns the originally set airspeed in knots' do
        expect(airspeed.mach).to eq(0.5)
      end

      it 'ignores altitude and temperature parameters' do
        expect(airspeed.mach(altitude: 100.fl, temperature: -14.7)).to eq(0.5)
      end

      it 'adjusts the knots from a mach number based on altitude and temperature' do
        expect(airspeed.knots(altitude: 100.fl, temperature: -14.7)).to be_within(0.01).of(638.0*0.5)
      end

      it 'uses the last entry in the mach table if the altitude is above that entry' do
        expect(airspeed.knots(altitude: 380.fl, temperature: -14.7)).to be_within(0.01).of(574.0*0.5)
      end
    end
  end
end
