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
    @config ||= begin
      Configuration.new
    end

    if block_given?
      yield @config
    else
      @config
    end
  end

  def self.stop
    set_trace_func nil
  end
end
