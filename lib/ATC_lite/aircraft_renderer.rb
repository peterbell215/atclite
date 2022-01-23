# frozen_string_literal: true

require 'gtk3'

# Responsible for rendering an aircraft on the radar screen.
class AircraftRenderer
  attr_reader :aircraft, :atc_screen, :position_history

  delegate :position, to: :aircraft

  FONT_DESCRIPTION = Pango::FontDescription.new('Monospace 12').freeze

  def initialize(aircraft)
    @atc_screen = ATCScreen.instance
    @aircraft = aircraft
    @position_history = []
  end

  def draw(cr)
    save_position

    x = y = 0

    position_history.each_with_index do |pos, index|
      x, y = ATCScreen.instance.map(pos)
      draw_box(cr, x, y, index)
      puts "draw_radar_screen: #{position}[#{index}] -> (#{x}, #{y})"
    end

    draw_text(cr, x, y)
  end

  private

  def save_position
    @position_history.shift 1 if @position_history.size >= 4
    @position_history.push aircraft.position.dup
  end

  def draw_box(cr, x, y, index)
    grey_scale = 0.2 * (index + 1)
    cr.set_source_rgb(grey_scale, grey_scale, grey_scale)
    cr.set_line_width(1)
    cr.rectangle(x - 5, y - 5, 10, 10)
    cr.stroke
  end

  def draw_text(cr, x, y)
    cr.move_to(x + 15, y - 10)
    layout = cr.create_pango_layout
    layout.text = aircraft.callsign
    layout.font_description = FONT_DESCRIPTION
    cr.show_pango_layout(layout)
  end
end
