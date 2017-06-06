module CallGraph
  module Printers
    class Png
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def to_s
        unless `which dot`.empty?
          `dot -Tpng #{config.path(:dot)}`
        else
          raise 'Error: unable to find dot executable in $PATH'
        end
      end
    end
  end
end
