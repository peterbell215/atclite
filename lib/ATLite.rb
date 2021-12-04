# frozen_string_literal: true
require_relative "ATCLite/version"
require_relative 'ATCLite/ATCscreen'

module ATCLite
  class Error < StandardError; end
  # Your code goes here...

  ATCScreen.instance.start
end


