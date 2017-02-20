require 'call_graph'

namespace :call_graph do
  namespace :printer do
    desc 'write dot file'
    task :dot do
      lines = IO.read(CallGraph.config.tmp_path)
                .split("\n")
                .uniq
                .map { |line| line.split(',') }

      File.open("#{CallGraph.config.filename}.dot", 'w') do |file|
        file.write <<-DOT
digraph call_graph {
#{lines.map { |c, r, id| %(  "#{c}" -> "#{r}" [label="#{id}"];) }.join("\n")}
}
DOT
      end
    end

    desc 'write png file from dot file'
    task png: :dot do
      cmd = "dot -Tpng -o #{CallGraph.config.png_path} #{CallGraph.config.dot_path}"
      puts cmd
      `#{cmd}`
    end
  end
end
