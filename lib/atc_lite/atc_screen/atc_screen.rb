# frozen_string_literal: true

require 'gtk3'

require 'singleton'

require_relative 'aircraft_renderer'
require_relative 'navigation_aid_renderer'
require_relative 'intersection_renderer'

UI_FILE = "#{__dir__}/atc_lite.ui".freeze

module AtcScreen
  # Class that creates the ATC screen.
  class AtcScreen
    include Singleton

    # Constructor
    def initialize
      @aircraft_renderers = []
      @navigation_aid_renderers = []
      @intersection_renderers = []
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
      window_closedown(builder)
      setup_radar_screen(builder)
      setup_scale_slider(builder)
      setup_nav_aids_btn(builder)
      setup_intersection_btn(builder)

      GLib::Timeout.add(12_000) { @radar_screen.queue_draw }

      Gtk.main
    end

    # Sets the scale for the radar screen, and updates what elements should be rendered
    def scale=(scale)
      @scale = scale
      bounding_box
      navigation_aids
      intersections
    end

    # Draws the radar screen.
    def draw_radar_screen(context)
      puts 'draw_radar_screen'

      context.set_source_rgb(0.0, 0.2, 0.0)
      context.paint

      @aircraft_renderers.each { |aircraft_renderer| aircraft_renderer.draw(context) }
      @navigation_aid_renderers.each { |nav_renderer| nav_renderer.draw(context) }
      @intersection_renderers.each { |intersection_renderer| intersection_renderer.draw(context) }
    end

    def inspect
      "centre: #{@centre}, scale: #{@scale}"
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
      position.longitude.between?(@western_edge, @eastern_edge) &&
        position.latitude.between?(@southern_edge, @northern_edge)
    end

    def navigation_aid_labels?
      @navigation_aids_button.active?
    end

    def intersection_labels?
      @intersection_button.active?
    end

    private

    def setup_nav_aids_btn(builder)
      @navigation_aids_button = builder.get_object('navigation_aids_btn')
      @navigation_aids_button.signal_connect('toggled') { |_| @radar_screen.queue_draw }
    end

    def setup_intersection_btn(builder)
      @intersection_button = builder.get_object('intersection_btn')
      @intersection_button.signal_connect('toggled') { |_| @radar_screen.queue_draw }
    end

    def setup_scale_slider(builder)
      @scale_adjustment = builder.get_object('scale_adjustment')
      self.scale = @scale_adjustment.value
      @scale_adjustment.signal_connect('value_changed') do
        self.scale = @scale_adjustment.value
        @radar_screen.queue_draw
      end
    end

    def setup_radar_screen(builder)
      @radar_screen = builder.get_object('radar_screen')
      @radar_screen.signal_connect('draw') { |_widget, cr| draw_radar_screen(cr) }
    end

    def window_closedown(builder)
      window = builder.get_object('window')
      window.signal_connect('destroy') { Gtk.main_quit }

      quit_btn = builder.get_object('quit_btn')
      quit_btn.signal_connect('clicked') { Gtk.main_quit }
    end

    # Generates an array of renderers for navigation aids visible on the radar screen.
    def navigation_aids
      @navigation_aid_renderers =
        Navigation::RadioNavigationAid.all
                                      .select { |nav_aid| self.on_screen?(nav_aid) }
                                      .map { |navigation_aid| NavigationAidRenderer.new(navigation_aid) }
    end

    # Generates an array of renderers for navigation aids visible on the radar screen.
    def intersections
      @intersection_renderers =
        Navigation::Intersection.all
                                .select { |intersection| self.on_screen?(intersection) }
                                .map { |intersection| IntersectionRenderer.new(intersection) }
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
end
