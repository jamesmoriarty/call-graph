require 'set'
require 'binding_of_caller'

module CallGraph
  class Instrument
    attr_accessor :file_path, :ignore_paths, :ignore_methods, :set

    def initialize(file_path: default_file_path, ignore_paths: default_ignore_paths, ignore_methods: default_ignore_methods)
      @file_path      = file_path
      @ignore_paths   = ignore_paths
      @ignore_methods = ignore_methods
      @set            = Set.new
    end

    def path(kind)
      "#{file_path}.#{kind}"
    end

    def default_file_path
      'call_graph'
    end

    def default_ignore_paths
      [
        /#{RUBY_VERSION}/,
        /\(eval\)/,
        /bundle\/gems/,
        /spec/,
        /test/
      ]
    end

    def default_ignore_methods
      [
        :require,
        :set_encoding,
        :initialize,
        :new,
        :attr_reader,
        :method_added,
        :private,
        :inherited,
        :singleton_method_added,
        :set_trace_func,
        :call
      ]
    end

    # :nocov:
    # NOTE: - some calls outside the trace proc cause the vm to segvault.
    #       - i've be unable to extract methods because of the above.
    def start
      set_trace_func ->(event, file, _line, id, receiver_binding, classname) {
        return if ignore_paths.any? { |path| file[path] }

        case event
        when 'call', 'c-call'
          caller_binding = receiver_binding.of_caller(2)

          caller_class = caller_binding.eval('self.class == Class ? self.name : self.class.name')
          caller_class = caller_binding.frame_description unless caller_class
          caller_class = caller_class + ' ' + caller_binding.eval("self.class == Class ? '(Class)' : '(Instance)'")


          receiver_class = receiver_binding.eval('self.class == Class ? self.name : self.class.name')
          receiver_class = caller_binding.frame_description if receiver_class.nil?
          receiver_class = receiver_class + ' ' + receiver_binding.eval("self.class == Class ? '(Class)' : '(Instance)'")

          return if classname == CallGraph
          return if caller_class == receiver_class
          return if ignore_methods.include?(id)

          set.add("#{caller_class},#{receiver_class},#{id}")
        end
      }
    end

    def stop
      File.open(path(:tmp), 'w') { |fd| fd.write set.to_a.compact.join("\n") }
    end
  end
end
