# frozen_string_literal: true

require 'rspec'

RSpec.describe Altitude do
  describe '::transition_altitude' do
    it 'defaults to 6000ft' do
      expect(Altitude.transition_altitude).to eq(6000)
    end

    it 'can be changed to 8000ft' do
      Altitude.transition_altitude = 8000
      expect(Altitude.transition_altitude).to eq(8000)
    end
  end

  describe 'to_i' do
    subject(:altitude) { Altitude.new(1000) }

    specify { expect(altitude.to_i).to eq(1000) }
  end

  describe '#new' do
    context 'when the altitude is specified in feet' do
      subject(:altitude) { Altitude.new(1000) }

      specify { expect(altitude).to eq(1000.ft) }
    end

    context 'when the altitude is specified as a string' do
      specify { expect(Altitude.new('1000')).to eq(1000.ft) }
      specify { expect(Altitude.new('-010')).to eq(-10.ft) }
      specify do
        expect { Altitude.new('aaaa') }
          .to raise_error(AltitudeParameterError, 'The altitude string is: aaaa')
      end
    end

    context 'when the altitude is specified as a flight level' do
      subject(:altitude) { Altitude.new('FL100') }

      specify { expect(altitude).to eq(100.fl) }
    end
  end

  describe '#==' do
    specify { expect(Altitude.new(1000) == 1000.ft).to be true }
    specify { expect(Altitude.new(1000) == 2000.ft).to be false }
  end

  describe '#<=>' do
    context 'when both are altitudes' do
      specify { expect(Altitude.new(1000) <=> Altitude.new(1003)).to eq(-1) }
      specify { expect(Altitude.new(1000) <=> Altitude.new(1000)).to eq(0) }
      specify { expect(Altitude.new(1003) <=> Altitude.new(1000)).to eq(1) }
    end

    context 'when comparing to an integer' do
      specify { expect(Altitude.new(1000) <=> 1003).to eq(-1) }
      specify { expect(Altitude.new(1000) <=> 1000).to eq(0) }
      specify { expect(Altitude.new(1003) <=> 1000).to eq(1) }
    end
  end

  describe '#+' do
    specify { expect(1000.ft + 1000.ft).to eq 2000.ft}
    specify { expect(1000.ft + 1000).to eq 2000.ft }
    specify { expect(1000 + 1000.ft).to eq 2000 }
  end

  describe 'Integer::ft' do
    specify { expect(100.ft).to eq Altitude.new(100) }
  end

  describe 'Integer::fl' do
    specify { expect(0.fl). to eq Altitude.new(0) }
    specify { expect(50.fl).to eq Altitude.new(5_000) }
    specify { expect(330.fl).to eq Altitude.new(33_000) }
  end
end
