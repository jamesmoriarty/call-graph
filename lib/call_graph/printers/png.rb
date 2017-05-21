module CallGraph
  module Printers
    class Png
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def to_s
        `dot -Tpng #{config.path(:dot)}`
      end
    end
  end
end
