# frozen_string_literal: true

require 'rspec'

RSpec.describe ATCLite::AircraftRenderer do
  let(:atc_screen) { ATCLite::ATCScreen.instance }

  describe '#update' do
    subject(:aircraft_renderer) { ATCLite::AircraftRenderer.new(aircraft) }

    let(:aircraft) { instance_double('ATCLite::Aircraft', x: atc_screen.centre_x, y: atc_screen.centre_y) }
    let(:line_instances) { Array.new(4) { line_double } }

    let(:line_class) { class_double(Line).as_stubbed_const }

    before { allow(line_class).to receive(:new).and_return(*line_instances) }

    describe 'transforms the aircraft position to a screen position' do
      let(:box) { { left: Window.width / 2 - 5, right: Window.width / 2 + 5, top: Window.height / 2 - 5, bottom: Window.height / 2 + 5 } }

      before { aircraft_renderer.update }

      specify { line_parameters_correct?(line_instances[0], x1: box[:left], y1: box[:top], x2: box[:right], y2: box[:top]) }
      specify { line_parameters_correct?(line_instances[1], x1: box[:right], y1: box[:top], x2: box[:right], y2: box[:bottom]) }
      specify { line_parameters_correct?(line_instances[2], x1: box[:right], y1: box[:bottom], x2: box[:left], y2: box[:bottom]) }
      specify { line_parameters_correct?(line_instances[3], x1: box[:left], y1: box[:bottom], x2: box[:left], y2: box[:top]) }
    end

    def line_double
      line_instance = instance_double(Line)
      allow(line_instance).to receive(:x1=)
      allow(line_instance).to receive(:y1=)
      allow(line_instance).to receive(:x2=)
      allow(line_instance).to receive(:y2=)
      line_instance
    end

    def line_parameters_correct?(line_instance, x1:, y1:, x2:, y2:)
      expect(line_instance).to have_received(:x1=).with(x1)
      expect(line_instance).to have_received(:y1=).with(y1)
      expect(line_instance).to have_received(:x2=).with(x2)
      expect(line_instance).to have_received(:y2=).with(y2)
    end
  end
end
