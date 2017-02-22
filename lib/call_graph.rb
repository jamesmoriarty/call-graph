require 'binding_of_caller'

require 'call_graph/version'
require 'call_graph/configuration'
require 'call_graph/printers/dot'
require 'call_graph/printers/png'

module CallGraph
  def self.start
    config.start
  end

  def self.config
    Configuration.new
  end

  def self.stop
    set_trace_func nil
  end
end
