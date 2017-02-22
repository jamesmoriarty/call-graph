require 'call_graph'

namespace :call_graph do
  namespace :printer do
    desc 'write dot file'
    task :dot do
      CallGraph::Printers::Dot.new(CallGraph.config).print
    end

    desc 'write png file from dot file'
    task png: :dot do
      CallGraph::Printers::Png.new(CallGraph.config).print
    end
  end
end
