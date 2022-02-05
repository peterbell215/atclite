# frozen_string_literal: true

require 'gtk3'

require_relative 'symbology'

module AtcScreen
  # Responsible for rendering a VOR symbol on the radar screen.
  class NavigationAidRenderer
    include Symbology

    attr_reader :navigation_aid, :atc_screen

    delegate :position, :name, to: :navigation_aid

    RADIUS = 6
    HALF_RADIUS = RADIUS / 2
    FONT_DESCRIPTION = Pango::FontDescription.new('Monospace 12').freeze

    def initialize(navigation_aid)
      @atc_screen = AtcScreen.instance
      @navigation_aid = navigation_aid
    end

    def draw(context)
      context.set_source_rgb(0.6, 0.6, 0.6)
      context.set_line_width(1)

      x, y = AtcScreen.instance.map(navigation_aid)

      draw_hexagon(context, x, y)
      draw_text(context, x, y) if @atc_screen.navigation_aid_labels?
    end
  end
end
