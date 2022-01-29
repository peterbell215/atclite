# frozen_string_literal: true

require 'gtk3'

require 'singleton'

require_relative 'aircraft_renderer'
require_relative 'navigation_aid_renderer'

UI_FILE = "#{__dir__}/atc_lite.ui".freeze

# Class that creates the ATC screen.
class AtcScreen
  include Singleton

  # Constructor
  def initialize
    @aircraft_renderers = []
    @navigation_aid_renderers = []
    @centre = Coordinate.new(longitude: 0.0, latitude: 52.0)
  end

  # Defines the centre of the radar screen
  attr_reader :centre

  # Defines the scale of the radar screen measured in pixels per NM
  attr_reader :scale

  # Reference to the Gtk3::GtDrawingArea
  attr_reader :radar_screen

  # Starts the process of drawing the radar screen when a draw event is received, or every 12 seconds.
  def start
    builder = Gtk::Builder.new(file: UI_FILE)

    # Connect signal handlers to the constructed widgets
    window = builder.get_object('window')
    window.signal_connect('destroy') { Gtk.main_quit }

    quit_btn = builder.get_object('quit_btn')
    quit_btn.signal_connect('clicked') { Gtk.main_quit }

    @radar_screen = builder.get_object('radar_screen')
    @radar_screen.signal_connect('draw') { |_widget, cr| draw_radar_screen(cr) }

    self.scale = 5

    GLib::Timeout.add(12_000) { @radar_screen.queue_draw }

    Gtk.main
  end

  # Sets the scale for the radar screen, and updates what elements should be rendered
  def scale=(scale)
    @scale = scale
    bounding_box
    navigation_aids
  end

  # Draws the radar screen.
  def draw_radar_screen(context)
    puts 'draw_radar_screen'

    context.set_source_rgb(0.0, 0.2, 0.0)
    context.paint

    @aircraft_renderers.each { |aircraft_renderer| aircraft_renderer.draw(context) }
    @navigation_aid_renderers.each { |vor_renderer| vor_renderer.draw(context) }
  end

  # Maps a position in the simulator space to an x, y coordinate on the ATC screen based on the ATC screen centre and
  # scale.
  def map(position)
    x = radar_screen.allocated_width / 2 + centre.delta_x(position) * scale
    y = radar_screen.allocated_height / 2 - centre.delta_y(position) * scale
    [x, y]
  end

  def add_aircraft(aircraft)
    @aircraft_renderers.push(AircraftRenderer.new(aircraft))
  end

  # Returns whether the passed position is visible on the radar screen.
  def on_screen?(position)
    position.longitude.between?(@eastern_edge, @western_edge) &&
      position.latitude.between?(@southern_edge, @northern_edge)
  end

  private

  # Generates an array of renderers for navigation aids visible on the radar screen.
  def navigation_aids
    @navigation_aid_renderers =
      Navigation::RadioNavigationAid.all
                                    .select { |nav_aid| self.on_screen?(nav_aid) }
                                    .each { |navigation_aid| NavigationAidRenderer.new(navigation_aid) }
  end

  # Calculates the bounding box that defines the outer boundaries in latitudes and longitudes of the current radar
  # screen.
  def bounding_box
    x_to_edge = radar_screen.allocated_width / (2 * scale)
    y_to_edge = radar_screen.allocated_height / (2 * scale)

    @western_edge = centre.new_position(heading: 270.0.degrees, distance: x_to_edge).longitude
    @eastern_edge = centre.new_position(heading: 90.0.degrees, distance: x_to_edge).longitude
    @northern_edge = centre.new_position(heading: 0.0.degrees, distance: y_to_edge).latitude
    @southern_edge = centre.new_position(heading: 180.0.degrees, distance: y_to_edge).latitude

    puts("bounding box: N: #{@northern_edge}, S: #{@southern_edge}, E: #{@eastern_edge}, W: #{@western_edge}")
  end
end
