require 'test_helper'

require_relative '../examples/foobar'

class CallGraphTest < Minitest::Test
  def call_graph_tmp
    IO.read CallGraph.tmp_path
  end

  def call_graph_dot
    IO.read "#{CallGraph.filename}.dot"
  end

  def setup
    ['tmp', 'dot', 'png'].each do |ext|
      `rm -f #{CallGraph.filename}.#{ext}`
    end

    CallGraph.start
    Foo.x
    CallGraph.stop
  end

  def teardown

  end

  def test_that_it_has_a_version_number
    refute_nil ::CallGraph::VERSION
  end

  def test_foobar_tmp
    assert_equal call_graph_tmp, <<-TXT
CallGraphTest (Instance),Foo (Class),x
CallGraphTest (Instance),Foo (Class),new
Foo (Class),Bar (Instance),y
TXT
  end

  def test_foobar_dot
    Rake::Task['call_graph:printer:dot'].invoke

    assert_equal call_graph_dot, <<-TXT
digraph call_graph {
  "CallGraphTest (Instance)" -> "Foo (Class)" [label="x"];
  "CallGraphTest (Instance)" -> "Foo (Class)" [label="new"];
  "Foo (Class)" -> "Bar (Instance)" [label="y"];
}
TXT
  end
end
