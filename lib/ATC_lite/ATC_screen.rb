# frozen_string_literal: true
require 'ruby2d'
require 'singleton'

module ATCLite
  # include Ruby2D

  class ATCScreen
    include Singleton

    def start
      Window.set title: "Hello Triangle"

      Triangle.new(
        x1: 320, y1:  50,
        x2: 540, y2: 430,
        x3: 100, y3: 430,
        color: %w[red green blue]
      )

      Square.new(
        x: 100, y: 200,
        size: 125,
        color: 'green',
        z: 10
      )

      Window.show
    end
  end
end
