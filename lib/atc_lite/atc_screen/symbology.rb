# frozen_string_literal: true

require 'gtk3'

module AtcScreen
  # Provides common drawing methods for the ATC Screen
  module Symbology
    # rubocop: disable Naming/MethodParameterName x, y are obvious names for these parameters
    def draw_hexagon(context, x, y)
      context.move_to(x - self.class::HALF_RADIUS, y - self.class::RADIUS)
      context.line_to(x + self.class::HALF_RADIUS, y - self.class::RADIUS)
      context.line_to(x + self.class::RADIUS, y)
      context.line_to(x + self.class::HALF_RADIUS, y + self.class::RADIUS)
      context.line_to(x - self.class::HALF_RADIUS, y + self.class::RADIUS)
      context.line_to(x - self.class::RADIUS, y)
      context.close_path
      context.stroke
    end

    def draw_triangle(context, x, y)
      context.move_to(x, y - self.class::RADIUS)
      context.line_to(x + self.class::RADIUS, y + self.class::RADIUS)
      context.line_to(x - self.class::RADIUS, y + self.class::RADIUS)
      context.close_path
      context.stroke
    end

    def draw_text(context, x, y)
      context.move_to(x + 15, y - 10)
      layout = context.create_pango_layout
      layout.text = self.name
      layout.font_description = self.class::FONT_DESCRIPTION
      context.show_pango_layout(layout)
    end
    # rubocop: enable Naming/MethodParameterName
  end
end
