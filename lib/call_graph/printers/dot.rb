module CallGraph
  module Printers
    class Dot
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def print
        File.open(dot_path, 'w') do |file|
          file.write to_s
        end
      end

      def to_s
        ERB.new(TEMPLATE, 0, '>').result(binding)
      end

      private

      class Line
        attr_reader :caller, :receiver, :attributes

        def initialize(caller, receiver, attributes = {})
          @caller     = caller
          @receiver   = receiver
          @attributes = attributes
        end
      end

      def dot_path
        config.dot_path
      end

      def tmp_path
        config.tmp_path
      end

      def lines
        IO.read(tmp_path)
          .split("\n")
          .uniq
          .map { |line| line.split(',') }
          .map { |c, r, id| Line.new(c, r, label: id) }
      end

      TEMPLATE = <<-EOF.freeze
digraph call_graph {
<% lines.each do |line| %>
  "<%= line.caller %>" -> "<%= line.receiver %>" [<% line.attributes.each do |(name, value)| %><%= name %>="<%= value %>"<% end %>];
<% end %>}
EOF
    end
  end
end
