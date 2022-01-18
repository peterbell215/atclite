# frozen_string_literal: true

require 'gtk3'

# Responsible for rendering an aircraft on the radar screen.
class AircraftRenderer
  attr_reader :aircraft, :atc_screen

  delegate :position, to: :aircraft

  #
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
  end
end
