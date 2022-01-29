# frozen_string_literal: true

require 'gtk3'

module AtcScreen
  # Responsible for rendering an aircraft on the radar screen.
  class AircraftRenderer
    attr_reader :aircraft, :atc_screen, :position_history

    delegate :position, to: :aircraft

    FONT_DESCRIPTION = Pango::FontDescription.new('Monospace 12').freeze

    def initialize(aircraft)
      @atc_screen = AtcScreen.instance
      @aircraft = aircraft
      @position_history = []
    end

    def draw(context)
      save_position

      x = y = 0

      position_history.each_with_index do |pos, index|
        x, y = AtcScreen.instance.map(pos)
        draw_box(context, x, y, index)
        puts "draw_radar_screen: #{position}[#{index}] -> (#{x}, #{y})"
      end

      draw_text(context, x, y)
    end

    private

    def save_position
      @position_history.shift 1 if @position_history.size >= 4
      @position_history.push aircraft.position.dup
    end

    # rubocop: disable Naming/MethodParameterName x, y are the obvious parameter names
    def draw_box(context, x, y, index)
      grey_scale = 0.2 * (index + 1)
      context.set_source_rgb(grey_scale, grey_scale, grey_scale)
      context.set_line_width(1)
      context.rectangle(x - 5, y - 5, 10, 10)
      context.stroke
    end

    def draw_text(context, x, y)
      context.move_to(x + 15, y - 10)
      layout = context.create_pango_layout
      layout.text = aircraft.callsign
      layout.font_description = FONT_DESCRIPTION
      context.show_pango_layout(layout)
    end
    # rubocop: enable Naming/MethodParameterName x, y are the obvious parameter names
  end
end
