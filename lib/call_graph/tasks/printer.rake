require 'call_graph'

namespace :call_graph do
  namespace :printer do
    desc 'write dot file'
    task :dot do
      content = CallGraph::Printers::Dot.new(CallGraph.config).to_s
      path    = CallGraph.config.path(:dot)

      write_file(path, content)
    end

    desc 'write png file from dot file'
    task png: :dot do
      content = CallGraph::Printers::Png.new(CallGraph.config).to_s
      path    = CallGraph.config.path(:png)

      write_file(path, content)
    end

    private

    def write_file(path, content)
      File.open(path, 'w') do |file|
        file.write content
      end
    end
  end
end
