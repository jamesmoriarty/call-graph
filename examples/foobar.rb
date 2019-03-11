# require "bundler/setup"
# require "call_graph"
# require "pry"

class A
  def self.x
    B.new.y
  end
end

class B
  def y
    1 + C.z do
      1
    end
  end
end

class C
  def self.z
    yield
  end
end

CallGraph.config do |config|
  config.file_path = "examples/call-graph"
end

[
  CallGraph.config.path(:dot),
  CallGraph.config.path(:tmp),
  CallGraph.config.path(:png)
].each do |path|
  `rm -f #{path}`
end

CallGraph.trace do
  A.x
end
