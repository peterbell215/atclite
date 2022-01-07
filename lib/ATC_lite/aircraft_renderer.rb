# frozen_string_literal: true

require 'ruby2d'

# Responsible for rendering an aircraft on the radar screen.
class AircraftRenderer
  BOX_LINE_X = Array.new(4) { |i| (i.zero? || i == 3 ? - 5 : +5) }
  BOX_LINE_Y = Array.new(4) { |i| (i <= 1 ? -5 : + 5) }

  # @param [Aircraft] aircraft
  def initialize(aircraft)
    @atc_screen = ATCScreen.instance
    @aircraft = aircraft

    @box_lines = Array.new(4) { Line.new(color: 'green') }
  end

  attr_reader :aircraft, :atc_screen

  def update
    screen_x = atc_screen.map_x(aircraft.x)
    screen_y = atc_screen.map_y(aircraft.y)

    @box_lines.each_with_index do |box_line, i|
      j = i + 1 & 0x3
      box_line.x1 = screen_x + BOX_LINE_X[i]
      box_line.y1 = screen_y + BOX_LINE_Y[i]
      box_line.x2 = screen_x + BOX_LINE_X[j]
      box_line.y2 = screen_y + BOX_LINE_Y[j]
    end
  end
end
