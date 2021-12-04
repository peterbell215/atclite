# frozen_string_literal: true
require 'ruby2d'
require 'singleton'

module ATCLite
  class ATCScreen < Window
    include Singleton

    def start
      set title: "Hello Triangle"

      Triangle.new(
        x1: 320, y1:  50,
        x2: 540, y2: 430,
        x3: 100, y3: 430,
        color: %w[red green blue]
      )

      show
    end
  end
end