require 'binding_of_caller'

require 'call_graph/version'

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

  class Configuration
    attr_reader :filename, :ignore_paths, :ignore_methods

    def initialize(filename: default_filename, ignore_paths: default_ignore_paths, ignore_methods: default_ignore_methods)
      @filename       = filename
      @ignore_paths   = ignore_paths
      @ignore_methods = ignore_methods
    end

    def tmp_path
      "#{filename}.tmp"
    end

    def dot_path
      "#{filename}.dot"
    end

    def png_path
      "#{filename}.png"
    end

    def default_filename
      'call_graph'
    end

    def default_ignore_paths
      /#{RUBY_VERSION}|\(eval\)|\(erb\)|bundle\/gems|spec|test/
    end

    def default_ignore_methods
      [:require, :set_encoding, :initialize, :new, :attr_reader, :method_added, :private, :inherited, :singleton_method_added, :set_trace_func]
    end

    # :nocov:
    def start
      set_trace_func ->(event, file, _line, id, receiver_binding, classname) {
        # TODO: extract config.
        return if file[ignore_paths]

        case event
        when 'call', 'c-call'
          # NOTE: get binding of call from 2nd frame.
          caller_binding = receiver_binding.of_caller(2)

          # NOTE: extract method? VM segfaults when you call almost any method outside this function.
          caller_class = caller_binding.eval('self.class == Class ? self.name : self.class.name')
          caller_class = caller_binding.frame_description unless caller_class
          caller_class = caller_class + ' ' + caller_binding.eval("self.class == Class ? '(Class)' : '(Instance)'")

          # NOTE: caller context segfaults under different conditions. All code has to be inline.
          receiver_class = receiver_binding.eval('self.class == Class ? self.name : self.class.name')
          receiver_class = caller_binding.frame_description if receiver_class.nil? || receiver_class.empty?
          receiver_class = receiver_class + ' ' + receiver_binding.eval("self.class == Class ? '(Class)' : '(Instance)'")

          # TODO: extract config.
          return if classname == self
          return if classname == CallGraph
          return if caller_class == receiver_class
          return if receiver_class.nil?
          return if caller_class.nil?
          return if ignore_methods.include?(id)

          # TODO: extract config.
          File.open(tmp_path, 'a') { |fd| fd.write "#{caller_class},#{receiver_class},#{id}\n" }
        end
      }
    end
  end
end
