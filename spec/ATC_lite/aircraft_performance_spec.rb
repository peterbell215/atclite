require 'rspec'

RSpec.describe AircraftPerformance do
  subject(:aircraft_performance) { AircraftPerformance.new('A19N') }

  before { AircraftPerformance.load_file }



  describe 'Initialization from file' do
    specify { expect(aircraft_performance).not_to be_nil }
  end

  describe '#roc' do
    shared_examples 'roc' do |altitude, target_altitude, roc|
      altitude_change = case altitude <=> target_altitude
                        when 0 then 'at level flight'
                        when -1 then 'climbing'
                        when +1 then 'descending'
                        end

      context "when #{altitude_change} from #{altitude} to #{target_altitude}" do
        let(:aircraft) { instance_double(Aircraft, altitude: altitude, target_altitude: target_altitude) }

        it 'returns the correct roc' do
          expect(aircraft_performance.roc(aircraft)).to eq(roc)
        end
      end
    end

    it_behaves_like 'roc', 4000.ft, 10_000.ft, 2500
    it_behaves_like 'roc', 5000.ft, 10_000.ft, 2500
    it_behaves_like 'roc', 200.fl, 280.fl, 2200
    it_behaves_like 'roc', 280.fl, 330.fl, 1000
    it_behaves_like 'roc', 4000.ft, 4000.ft, 0
    it_behaves_like 'roc', 5000.ft, 5000.ft, 0
    it_behaves_like 'roc', 200.fl, 200.fl, 0
    it_behaves_like 'roc', 280.fl, 280.fl, 0
    it_behaves_like 'roc', 330.fl, 200.fl, -1000
    it_behaves_like 'roc', 290.fl, 200.fl, -1000
    it_behaves_like 'roc', 10_000.ft, 3000.ft, -3000
    it_behaves_like 'roc', 6000.ft, 3000.ft, -1500
  end
end
