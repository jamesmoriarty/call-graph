module CallGraph
  module Printers
    class Png
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def print
        puts `dot -Tpng -o #{png_path} #{dot_path}`
      end

      private

      def dot_path
        config.dot_path
      end

      def png_path
        config.png_path
      end
    end
  end
end
