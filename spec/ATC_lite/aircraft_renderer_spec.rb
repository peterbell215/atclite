# frozen_string_literal: true

require 'rspec'

RSpec.describe AircraftRenderer do
  let(:atc_screen) { ATCScreen.instance }

  describe '#draw' do
    subject(:aircraft_renderer) { AircraftRenderer.new(aircraft) }

    let(:aircraft) { instance_double('Aircraft', callsign: 'BA001') }
    let(:cr) { instance_double(Cairo::Context) }
    let(:layout) { instance_double(Pango::Layout) }
    let(:font_description) { instance_double(Pango::FontDescription) }

    describe 'draws a box on the radar screen' do
      before do
        allow(cr).to receive_messages(set_source_rgb: nil, set_line_width: nil, rectangle: nil, stroke: nil, move_to: nil )

        allow(cr).to receive(:create_pango_layout).and_return(layout)
        allow(cr).to receive(:show_pango_layout)
        allow(layout).to receive_messages(:text= => true, :font_description= => true)

        aircraft_renderer.draw(cr, 200, 200)
      end

      specify { expect(cr).to have_received(:rectangle).with(195, 195, 10, 10) }
      specify { expect(cr).to have_received(:move_to).with(215, 190) }
      specify { expect(layout).to have_received(:text=).with('BA001') }
    end
  end
end
