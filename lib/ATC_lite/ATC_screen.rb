# frozen_string_literal: true

require 'gtk3'

require 'singleton'

require_relative 'aircraft_renderer'

UI_FILE = "#{File.expand_path(File.dirname(__FILE__))}/atc_lite.ui".freeze

# Class that creates the ATC screen.
class ATCScreen
  include Singleton

  def initialize
    @aircraft_renderers = []
    @scale = 10
    @centre = Coordinate.new(longitude: 0.0, latitude: 52.0)
  end

  attr_reader :centre, :scale, :radar_screen

  def start
    builder = Gtk::Builder.new(file: UI_FILE)

    # Connect signal handlers to the constructed widgets
    window = builder.get_object('window')
    window.signal_connect('destroy') { Gtk.main_quit }

    quit_btn = builder.get_object('quit_btn')
    quit_btn.signal_connect('clicked') { Gtk.main_quit }

    @radar_screen = builder.get_object('radar_screen')
    @radar_screen.signal_connect('draw') { |_widget, cr| draw_radar_screen(cr) }

    GLib::Timeout.add(12_000){ @radar_screen.queue_draw }

    Gtk.main
  end

  def draw_radar_screen(cr)
    puts 'draw_radar_screen'

    cr.set_source_rgb(0.0, 0.2, 0.0)
    cr.paint

    @aircraft_renderers.each { |aircraft_renderer| aircraft_renderer.draw(cr) }
  end

  # Maps a position in the simulator space to an x, y  coordinate on the ATC screen based on the ATC screen centre and
  # scale.
  def map(position)
    x = radar_screen.allocated_width / 2 + centre.delta_x(position) * scale
    y = radar_screen.allocated_height / 2 - centre.delta_y(position) * scale
    [x, y]
  end

  def add_aircraft(aircraft)
    @aircraft_renderers.push(AircraftRenderer.new(aircraft))
  end

  def on_screen?(position)
    position.longitude.between?(@eastern_edge, @western_edge) &&
      position.latitude.between?(@southern_edge, @northern_edge)
  end

  # Maps a y position in the simulator space to a y coordinate on the ATC screen based on the ATC screen centre and
  # scale.
  def map_y(y)
     radar_screen.allocated_height / 2 - y * scale
  end

  def add_aircraft(aircraft)
    @aircraft_renderers.push(AircraftRenderer.new(aircraft))
  end
end
