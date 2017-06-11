module CallGraph
  module Printers
    class Png
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def to_s
        unless `which dot`.empty?
          `dot -Tpng #{src}`
        else
          raise 'Error: unable to find dot executable in $PATH'
        end
      end

      private

      def src
        config.path(:dot)
      end
    end
  end
end
