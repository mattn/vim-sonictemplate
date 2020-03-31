require 'benchmark'

Benchmark.bm 10 do |r|
  r.report "{{_input_:label}}" do
    {{_cursor_}}
  end
end
