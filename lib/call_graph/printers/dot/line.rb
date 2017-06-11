module CallGraph
  module Printers
    class Dot
      class Line
        attr_reader :caller, :receiver, :attributes

        def initialize(caller, receiver, attributes = {})
          @caller     = caller
          @receiver   = receiver
          @attributes = attributes
        end
      end
    end
  end
end
