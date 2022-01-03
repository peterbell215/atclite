# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

require 'ATC_lite'

task default: %i[spec rubocop]

class TestBoundingBox
  NORTH_WEST = Coordinate.new(latitude: 62.0, longitude: 3.0)
  SOUTH_EAST = Coordinate.new(latitude: 50.0, longitude: -11.0)
end

namespace :test_data do
  desc 'Generate a cut-down navigation dataset for testing covering only the UK'
  task :all do
    Rake::Task['test_data:apts'].invoke
    Rake::Task['test_data:navs'].invoke
    Rake::Task['test_data:intersections'].invoke
    Rake::Task['test_data:airways'].invoke
  end

  desc 'Extract a subset of airports covering UK airspace'
  task :apts do
    ATCLite::Navigation::AirportImporter.parse_apts_file unless ATCLite::Navigation::Airport.loaded?

    file = File.open('data/apts-uk.txt', 'w')

    ATCLite::Navigation::Airport.all.each do |airport|
      next if airport.name !~ /^EG[A-Z]{2}/ && !in_uk_airspace?(airport)

      file.puts ATCLite::Navigation::AirportImporter.output(airport, [5, 25, 6, 12, 12, 0])
    rescue StandardError
      warn("Standard error caught outputing airport #{airport.name}")
      raise
    end
  end

  desc 'Extract a subset of navigation aids close to UK airspace'
  task :navs do
    ATCLite::Navigation::RadioNavigationAidImporter.parse_navs_file unless ATCLite::Navigation::Intersection.loaded?

    file = File.open('data/navs-uk.txt', 'w')

    ATCLite::Navigation::RadioNavigationAid.all.each do |navigation_aid|
      next unless in_uk_airspace?(navigation_aid)

      file.puts ATCLite::Navigation::RadioNavigationAidImporter.output(navigation_aid, [10, 40, 13, 13, 4, 7, 0])
    rescue StandardError
      warn("Standard error caught outputing navigation aid #{navigation_aid.name}")
      raise
    end
  end

  desc 'Extract a subset of intersections close to UK airspace'
  task :intersections do
    ATCLite::Navigation::IntersectionImporter.parse_ints_file unless ATCLite::Navigation::Intersection.loaded?

    file = File.open('data/ints-uk.txt', 'w')

    ATCLite::Navigation::Intersection.all.each do |intersection|
      next unless in_uk_airspace?(intersection)

      file.puts ATCLite::Navigation::IntersectionImporter.output(intersection, [10, 26, 13, 13, 7, 0])
    rescue StandardError
      warn("Standard error caught outputing intersection #{intersection.name}")
      raise
    end
  end

  desc 'Extract a subset of airways that intersect UK airspace'
  task :airways do
    ATCLite::Navigation::RadioNavigationAidImporter.parse_navs_file unless ATCLite::Navigation::RadioNavigationAid.loaded?
    ATCLite::Navigation::IntersectionImporter.parse_ints_file unless ATCLite::Navigation::Intersection.loaded?
    ATCLite::Navigation::AirwayImporter.parse_awys_file unless ATCLite::Navigation::Airway.loaded?

    file = File.open('data/awys-uk.txt', 'w')

    ATCLite::Navigation::Airway.all.each do |airway|
      next unless airway.any? { |waypoint| in_uk_airspace?(waypoint) }

      file.puts ATCLite::Navigation::AirwayImporter.output_airway(airway, [8, 5, 20, 14, 14, 0])
    rescue StandardError
      warn("Standard error caught outputing airway #{airway.name}")
      raise
    end
  end

  def in_uk_airspace?(coord)
    coord.longitude.between?(TestBoundingBox::SOUTH_EAST.longitude, TestBoundingBox::NORTH_WEST.longitude) &&
      coord.latitude.between?(TestBoundingBox::SOUTH_EAST.latitude, TestBoundingBox::NORTH_WEST.latitude)
  end
end
