# frozen_string_literal: true

require 'dev_oops/version'

require 'fileutils'
require 'json'
require 'thor'

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.setup # ready!

module DevOops
  class Error < StandardError
  end
end

loader.eager_load
