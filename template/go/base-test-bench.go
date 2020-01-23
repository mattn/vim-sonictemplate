package {{_expr_:substitute('{{_name_}}', '_test', '', '')}}

import (
	"testing"
)

func BenchmarkSimple(b *testing.B) {
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		{{_cursor_}}
	}
}
{{_filter_:benchmark}}
