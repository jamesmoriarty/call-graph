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
    1 + z
  end

  def z
    1
  end
end

CallGraph.config do |config|
  config.filename = "examples/call-graph"
end

[
  CallGraph.config.path(:dot),
  CallGraph.config.path(:tmp),
  CallGraph.config.path(:png)
].each do |path|
  `rm -f #{path}`
end

CallGraph.start
Foo.x
CallGraph.stop
