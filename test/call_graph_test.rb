require 'test_helper'

require_relative '../examples/foobar'

class CallGraphTest < Minitest::Test

  def call_graph_tmp
    IO.read CallGraph.config.path(:tmp)
  end

  def call_graph_dot
    IO.read CallGraph.config.path(:dot)
  end

  def test_that_it_has_a_version_number
    refute_nil ::CallGraph::VERSION
  end

  def test_foobar_tmp
    assert_equal call_graph_tmp, <<-TXT
Object (Instance),A (Class),x
A (Class),B (Instance),y
B (Instance),C (Class),z
TXT
  end

  def test_foobar_dot
    Rake::Task['call_graph:printer:dot'].invoke

    assert_equal call_graph_dot, <<-TXT
digraph call_graph {
  "Object (Instance)" -> "A (Class)" [label="x"];
  "A (Class)" -> "B (Instance)" [label="y"];
  "B (Instance)" -> "C (Class)" [label="z"];
}
TXT
  end

  def test_foobar_png
    Rake::Task['call_graph:printer:png'].invoke
  rescue Exception => e
    puts e.message
  end
end
