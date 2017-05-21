require 'call_graph'

namespace :call_graph do
  namespace :printer do
    desc 'write dot file'
    task :dot do
      File.open(CallGraph.config.path(:dot), 'w') do |file|
        file.write CallGraph::Printers::Dot.new(CallGraph.config).to_s
      end
    end

    desc 'write png file from dot file'
    task png: :dot do
      File.open(CallGraph.config.path(:png), 'w') do |file|
        file.write CallGraph::Printers::Png.new(CallGraph.config).to_s
      end
    end
  end
end
