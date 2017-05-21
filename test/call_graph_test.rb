require 'test_helper'

require_relative '../examples/foobar'

class CallGraphTest < Minitest::Test
  def call_graph_tmp
    IO.read CallGraph.config.path(:tmp)
  end

  def call_graph_dot
    IO.read CallGraph.config.path(:dot)
  end

  def setup
    [
      CallGraph.config.path(:dot),
      CallGraph.config.path(:tmp),
      CallGraph.config.path(:png)
    ].each do |path|
      `rm -f #{path}`
    end

    CallGraph.config do |config|
      config.filename = "examples/call-graph"
    end

    CallGraph.start
    Foo.x
    CallGraph.stop
  end

  def test_that_it_has_a_version_number
    refute_nil ::CallGraph::VERSION
  end

  def test_foobar_tmp
    assert_equal call_graph_tmp, <<-TXT
CallGraphTest (Instance),Foo (Class),x
Foo (Class),Bar (Instance),y
TXT
  end

  def test_foobar_dot
    Rake::Task['call_graph:printer:dot'].invoke

    assert_equal call_graph_dot, <<-TXT
digraph call_graph {
  "CallGraphTest (Instance)" -> "Foo (Class)" [label="x"];
  "Foo (Class)" -> "Bar (Instance)" [label="y"];
}
TXT
  end
end
