# frozen_string_literal: true

# require 'ruby2d'
require 'gtk3'

require 'singleton'

require_relative 'aircraft_renderer'

UI_FILE = "#{File.expand_path(File.dirname(__FILE__))}/atc_lite.ui"

# Class that creates the ATC screen.
class ATCScreen
  include Singleton

  def initialize
    @aircraft_renderers = []
    @scale = 10
    @centre_x = 100
    @centre_y = 100
  end

  attr_reader :centre_x, :centre_y, :scale

  def start
    builder = Gtk::Builder.new(file: UI_FILE)

    # Connect signal handlers to the constructed widgets
    window = builder.get_object("window")
    window.signal_connect("destroy") { Gtk.main_quit }

    quit_btn = builder.get_object("quit_btn")
    quit_btn.signal_connect("clicked") { Gtk.main_quit }

    @radar_screen = builder.get_object("radar_screen")
    @radar_screen.signal_connect("draw") { |_widget, cr| draw_radar_screen(cr) }

    Gtk.main
  end

  def draw_radar_screen(cr)
    puts 'draw_radar_screen'

    # cr = Cairo::Context.new(@surface)
    # cr.rectangle(x - 3, y - 3, 6, 6)
    cr.set_source_rgb(0.0, 0.2, 0.0)
    cr.paint

    cr.set_source_rgb(0.6, 0.6, 0.6)
    cr.set_line_width(1)

    cr.rectangle(20, 20, 120, 80)
    cr.rectangle(180, 20, 80, 80)
    cr.stroke_preserve
    # cr.fill

    # cr.arc(330, 60, 40, 0, 2.0*Math::PI);
    # cairo_stroke_preserve(cr);
    # cairo_fill(cr);

    # cr.fill
    # cr.destroy
    # @radar_screen.queue_draw_area(x - 3, y - 3, 6, 6)
  end

  # Maps a x position in the simulator space to a x coordinate on the ATC screen based on the ATC screen centre and
  # scale.
  def map_x(x)
    (x - @centre_x) * @scale + Window.width / 2
  end

  # Maps a y position in the simulator space to a y coordinate on the ATC screen based on the ATC screen centre and
  # scale.
  def map_y(y)
    (y - @centre_y) * @scale + Window.height / 2
  end

  def add_aircraft(aircraft)
    @aircraft_renderers.push(AircraftRenderer.new(aircraft))
  end
end
