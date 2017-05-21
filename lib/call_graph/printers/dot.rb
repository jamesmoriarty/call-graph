module CallGraph
  module Printers
    class Dot
      attr_reader :config

      def initialize(config)
        @config = config
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

      def lines
        IO.read(config.path(:tmp))
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
