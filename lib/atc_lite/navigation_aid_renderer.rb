# frozen_string_literal: true

require 'gtk3'

# Responsible for rendering a VOR symbol on the radar screen.
class NavigationAidRenderer
  attr_reader :navigation_aid, :atc_screen

  delegate :position, to: :navigation_aid

  RADIUS = 6
  HALF_RADIUS = RADIUS/2
  FONT_DESCRIPTION = Pango::FontDescription.new('Monospace 12').freeze

  def initialize(navigation_aid)
    @atc_screen = AtcScreen.instance
    @navigation_aid = navigation_aid
  end

  def draw(cr)
    cr.set_source_rgb(0.6, 0.6, 0.6)
    cr.set_line_width(1)

    x, y = AtcScreen.instance.map(navigation_aid)

    draw_hexagon(cr, x, y)
    draw_text(cr, x, y)
  end

  private

  def draw_hexagon(cr, x, y)
    cr.move_to(x - HALF_RADIUS, y - RADIUS)
    cr.line_to(x + HALF_RADIUS, y - RADIUS)
    cr.line_to(x + RADIUS, y)
    cr.line_to(x + HALF_RADIUS, y + RADIUS)
    cr.line_to(x - HALF_RADIUS, y + RADIUS)
    cr.line_to(x - RADIUS, y)
    cr.close_path
    cr.stroke
  end

  def draw_text(cr, x, y)
    cr.move_to(x + 15, y - 10)
    layout = cr.create_pango_layout
    layout.text = navigation_aid.name
    layout.font_description = FONT_DESCRIPTION
    cr.show_pango_layout(layout)
  end
end
