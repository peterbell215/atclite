# frozen_string_literal: true

require 'gtk3'

module AtcScreen
  # Responsible for rendering a VOR symbol on the radar screen.
  class NavigationAidRenderer
    attr_reader :navigation_aid, :atc_screen

    delegate :position, to: :navigation_aid

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

      navigation_aid.navtype == 'VOR' ? draw_hexagon(context, x, y) : draw_triangle(context, x, y)
      draw_text(context, x, y) if @atc_screen.navigation_aid_labels?
    end

    private

    # rubocop: disable Naming/MethodParameterName x, y are obvious names for these parameters
    def draw_hexagon(context, x, y)
      context.move_to(x - HALF_RADIUS, y - RADIUS)
      context.line_to(x + HALF_RADIUS, y - RADIUS)
      context.line_to(x + RADIUS, y)
      context.line_to(x + HALF_RADIUS, y + RADIUS)
      context.line_to(x - HALF_RADIUS, y + RADIUS)
      context.line_to(x - RADIUS, y)
      context.close_path
      context.stroke
    end

    def draw_triangle(context, x, y)
      context.move_to(x, y - RADIUS)
      context.line_to(x + RADIUS, y + RADIUS)
      context.line_to(x - RADIUS, y + RADIUS)
      context.close_path
      context.stroke
    end

    def draw_text(context, x, y)
      context.move_to(x + 15, y - 10)
      layout = context.create_pango_layout
      layout.text = navigation_aid.name
      layout.font_description = FONT_DESCRIPTION
      context.show_pango_layout(layout)
    end
    # rubocop: enable Naming/MethodParameterName
  end
end
