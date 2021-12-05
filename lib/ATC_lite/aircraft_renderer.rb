# frozen_string_literal: true

require 'ruby2d'

module ATCLite
  # Responsible for rendering an aircraft on the radar screen.
  class AircraftRenderer
    BOX_LINE_X = Array.new(4) { |i| (i.zero? || i == 3 ? - 5 : +5) }
    BOX_LINE_Y = Array.new(4) { |i| (i <= 1 ? -5 : + 5) }

    # @param [Aircraft] aircraft
    def initialize(aircraft)
      @aircraft = aircraft

      @box_lines = Array.new(4) { Line.new(color: 'green') }
    end

    attr_reader :aircraft

    def update
      @box_lines.each_with_index do |box_line, i|
        j = i + 1 & 0x3
        box_line.x1 = aircraft.x + BOX_LINE_X[i]
        box_line.y1 = aircraft.y + BOX_LINE_Y[i]
        box_line.x2 = aircraft.x + BOX_LINE_X[j]
        box_line.y2 = aircraft.y + BOX_LINE_Y[j]
      end
    end
  end
end
