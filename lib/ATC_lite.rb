# frozen_string_literal: true
require_relative "ATC_lite/version"
require_relative 'ATC_lite/ATC_screen'

module ATCLite
  class Error < StandardError; end
  # Your code goes here...

  ATCScreen.instance.start
end


