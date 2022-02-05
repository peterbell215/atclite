# frozen_string_literal: true

require 'gtk3'

require_relative 'symbology'

module AtcScreen
  # Responsible for rendering a VOR symbol on the radar screen.
  class IntersectionRenderer
    include Symbology

    attr_reader :intersection, :atc_screen

    delegate :position, :name, to: :intersection

    RADIUS = 6
    HALF_RADIUS = RADIUS / 2
    FONT_DESCRIPTION = Pango::FontDescription.new('Monospace 12').freeze

    def initialize(intersection)
      @atc_screen = AtcScreen.instance
      @intersection = intersection
    end

    def draw(context)
      context.set_source_rgb(0.6, 0.6, 0.6)
      context.set_line_width(1)

      x, y = AtcScreen.instance.map(intersection)

      draw_triangle(context, x, y)
      draw_text(context, x, y) if @atc_screen.intersection_labels?
    end

    def to_s
      "IntersectionRenderer for #{name} @ #{position}"
    end
  end
end
