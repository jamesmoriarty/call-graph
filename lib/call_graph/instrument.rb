require 'set'
require 'binding_of_caller'

module CallGraph
  class Instrument
    INTROSPECT = "(self.class == Class ? self.name : self.class.name) + ' ' + (self.class == Class ? '(Class)' : '(Instance)') rescue binding.source_location"

    attr_accessor :file_path, :set

    def initialize(file_path: default_file_path)
      @file_path      = file_path
      @set            = Set.new
    end

    def path(kind)
      "#{file_path}.#{kind}"
    end

    def trace(&block)
      trace_point.enable
      yield
      trace_point.disable

      File.open(path(:tmp), 'w') { |fd| fd.write set.to_a.compact.join("\n") }

      set.clear
    end

    private

    def default_file_path
      'call-graph'
    end

    def trace_point
      @trace_point ||= begin
        TracePoint.new(:call) do |trace|
          next if trace.defined_class == self.class

          case trace.event
          when :call
            id       = trace.method_id
            caller   = trace.binding.of_caller(2).eval(INTROSPECT)
            receiver = trace.binding.eval(INTROSPECT)

            next if caller == receiver
          
            set.add("#{caller},#{receiver},#{id}")
          end
        end
      end
    end
  end
end
