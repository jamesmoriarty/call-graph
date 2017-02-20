require 'call_graph'

namespace :call_graph do
  namespace :printer do
    desc 'write dot file'
    task :dot do
      dot_path = CallGraph.config.dot_path
      lines    = IO.read(CallGraph.config.tmp_path)
                .split("\n")
                .uniq
                .map { |line| line.split(',') }
                .map { |c, r, id| %(  "#{c}" -> "#{r}" [label="#{id}"];) }
                .join("\n")

      File.open(dot_path, 'w') do |file|
        file.write <<-DOT
digraph call_graph {
#{lines}
}
DOT
      end
    end

    desc 'write png file from dot file'
    task png: :dot do
      png_path = CallGraph.config.png_path
      dot_path = CallGraph.config.dot_path

      puts %x[ dot -Tpng -o #{png_path} #{dot_path} ]
    end
  end
end
