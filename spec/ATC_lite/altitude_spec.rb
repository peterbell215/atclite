# frozen_string_literal: true

require 'rspec'

RSpec.describe ATCLite::Altitude do
  describe '::transition_altitude' do
    it 'defaults to 6000ft' do
      expect(ATCLite::Altitude.transition_altitude).to eq(6000)
    end

    it 'can be changed to 8000ft' do
      ATCLite::Altitude.transition_altitude = 8000
      expect(ATCLite::Altitude.transition_altitude).to eq(8000)
    end
  end

  describe 'to_i' do
    subject(:altitude) { ATCLite::Altitude.new(1000) }

    specify { expect(altitude.to_i).to eq(1000) }
  end

  describe '#new' do
    context 'when the altitude is specified in feet' do
      subject(:altitude) { ATCLite::Altitude.new(1000) }

      specify { expect(altitude).to eq(1000.ft) }
    end
  end

  describe '#==' do
    specify { expect(ATCLite::Altitude.new(1000) == 1000.ft).to be true }
    specify { expect(ATCLite::Altitude.new(1000) == 2000.ft).to be false }
  end

  describe '#<=>' do
    context 'when both are altitudes' do
      specify { expect(ATCLite::Altitude.new(1000) <=> ATCLite::Altitude.new(1003)).to eq(-1) }
      specify { expect(ATCLite::Altitude.new(1000) <=> ATCLite::Altitude.new(1000)).to eq(0) }
      specify { expect(ATCLite::Altitude.new(1003) <=> ATCLite::Altitude.new(1000)).to eq(1) }
    end

    context 'when comparing to an integer' do
      specify { expect(ATCLite::Altitude.new(1000) <=> 1003).to eq(-1) }
      specify { expect(ATCLite::Altitude.new(1000) <=> 1000).to eq(0) }
      specify { expect(ATCLite::Altitude.new(1003) <=> 1000).to eq(1) }
    end
  end
end
