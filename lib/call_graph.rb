require 'call_graph/version'
require 'call_graph/instrument'
require 'call_graph/printers/dot'
require 'call_graph/printers/png'

module CallGraph
  def self.start
    config.start
  end

  def self.config
    if block_given?
      yield instrument
    else
      instrument
    end
  end

  def self.stop
    set_trace_func nil
  end

  private

  def self.instrument
    @instrument ||= begin
      Instrument.new
    end
  end
end
