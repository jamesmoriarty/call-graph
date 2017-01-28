require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'call_graph'

load './lib/call_graph/tasks/printer.rake'

require 'minitest/autorun'
