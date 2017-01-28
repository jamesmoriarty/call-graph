require 'call_graph'

namespace :call_graph do
  namespace :printer do
    desc "write dot file"
    task :dot do
      lines = IO.read(CallGraph.tmp_path)
        .split(?\n)
        .uniq
        .map { |line| line.split(?,) }

      File.open("#{CallGraph.filename}.dot", ?w) do |file|
        file.write <<-DOT
digraph call_graph {
#{lines.map { |c, r, id| %(  "#{c}" -> "#{r}" [label="#{id}"];)}.join(?\n) }
}
DOT
      end
    end

    desc "write png file from dot file"
    task png: :dot do
      `dot -Tpng -o #{CallGraph.filename}.png #{CallGraph.filename}.dot`
    end
  end
end
