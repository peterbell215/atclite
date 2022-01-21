# frozen_string_literal: true

require 'rspec'

RSpec.describe Aircraft::AircraftPerformance do
  subject(:aircraft_performance) { Aircraft::AircraftPerformance.new('A19N') }

  before { Aircraft::AircraftPerformance.load_file }

  describe 'Initialization from file' do
    specify { expect(aircraft_performance).not_to be_nil }
  end

  # rubocop: disable Metrics/ParameterLists; driven by the need to test a number of items at the same time.
  # rubocop: disable Layout/LineLength
  describe '#performance_data' do
    shared_examples 'the correct performance data is returned' do |altitude, target_altitude, current_phase, target_phase, speed, roc|
      context_string = case altitude <=> target_altitude
                       when 0 then "in the #{current_phase} and in level flight"
                       when -1 then "in the #{current_phase} and climbing to #{target_altitude}"
                       when +1 then "in the #{current_phase} descending to #{target_altitude}"
                       end

      context "when at #{altitude} #{context_string}" do
        let(:current_performance_data) { aircraft_performance.performance_data(aircraft) }
        let(:aircraft) do
          instance_double(Aircraft::Aircraft, altitude: altitude, target_altitude: target_altitude, phase: :climb)
        end

        specify 'for roc' do
          expect(current_performance_data.roc).to eq roc
        end

        specify 'for speed' do
          expect(current_performance_data.ias).to eq speed
        end

        specify 'for phase' do
          expect(current_performance_data.phase).to eq target_phase
        end
      end
    end
    # rubocop: enable Metrics/ParameterLists
    # rubocop: enable Layout/LineLength

    # rubocop: disable Layout/ExtraSpacing
    # rubocop: disable Layout/SpaceInsideArrayLiteralBrackets
    [
      # current_altitude, target_altitude,    current_phase,     target_phase, speed    ,   roc
      [          4000.ft,       10_000.ft,   :initial_climb,   :initial_climb, 165.knots,  2500 ],
      [          4000.ft,         4000.ft,   :initial_climb,   :initial_climb, 165.knots,     0 ],
      [          6000.ft,       10_000.ft,           :climb,           :climb, 290.knots,  2500 ],
      [          6000.ft,         6000.ft,           :climb,           :climb, 290.knots,     0 ],
      [           200.fl,          280.fl,           :climb,           :climb, 290.knots,  2200 ],
      [           200.fl,          200.fl,           :climb,           :climb, 290.knots,     0 ],
      [           280.fl,          330.fl,           :climb,           :climb, 0.78.mach,  1000 ],
      [           280.fl,          330.fl,          :cruise,           :climb, 0.78.mach,  1000 ],
      [           280.fl,          280.fl,           :climb,          :cruise, 0.78.mach,     0 ],
      [           330.fl,          280.fl,          :cruise, :initial_descent, 0.78.mach, -1000 ],
      [           330.fl,          200.fl, :initial_descent, :initial_descent, 0.78.mach, -1000 ],
      [           230.fl,          200.fl,         :descent,         :descent, 290.knots, -3000 ],
      [         9_000.ft,        3_000.ft,         :descent,        :approach, 230.knots, -1500 ]
    ].each do |params|
      it_behaves_like 'the correct performance data is returned', *params
    end
    # rubocop: enable Layout/SpaceInsideArrayLiteralBrackets
    # rubocop: enable Layout/ExtraSpacing
  end
end
