# require "bundler/setup"
# require "call_graph"
# require "pry"

class Foo
  def self.x
    Bar.new.y
  end
end

class Bar
  def y
    1 + 1
  end
end

CallGraph.start
Foo.x
CallGraph.stop
