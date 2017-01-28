require 'binding_of_caller'

require 'call_graph/version'

module CallGraph
  def self.filename
    'call_graph'
  end

  def self.tmp_path
    "#{filename}.tmp"
  end

  # :nocov:
  def self.start
    set_trace_func ->(event, file, _line, id, receiver_binding, classname) {
      # TODO: extract config.
      return if file[/#{RUBY_VERSION}|\(eval\)|\(erb\)|bundle\/gems|spec|test/]

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
        return if caller_class == receiver_class
        return if receiver_class.nil?
        return if caller_class.nil?
        return if [:require, :set_encoding, :initialize, :attr_reader, :method_added, :private, :inherited, :singleton_method_added, :set_trace_func].include?(id)

        # TODO: extract config.
        File.open(tmp_path, 'a') { |fd| fd.write "#{caller_class},#{receiver_class},#{id}\n" }
      end
    }
  end
  # :nocov:

  def self.stop
    set_trace_func nil
  end
end
