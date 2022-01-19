# frozen_string_literal: true

require 'gtk3'

# Responsible for rendering an aircraft on the radar screen.
class AircraftRenderer
  attr_reader :aircraft, :atc_screen

  delegate :position, to: :aircraft

  FONT_DESCRIPTION = Pango::FontDescription.new('Monospace 12').freeze

  def initialize(aircraft)
    @atc_screen = ATCScreen.instance
    @aircraft = aircraft
  end

  def draw(cr, x, y)
    puts 'rendering aircraft'

    cr.set_source_rgb(0.6, 0.6, 0.6)
    cr.set_line_width(1)

    cr.rectangle(x - 5, y - 5, 10, 10)
    cr.stroke

    cr.move_to(x + 15, y - 10)
    layout = cr.create_pango_layout
    layout.text = aircraft.callsign
    layout.font_description = FONT_DESCRIPTION
    cr.show_pango_layout(layout)
  end
end
