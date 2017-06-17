package {{_expr_:substitute('{{_name_}}', '_test', '', '')}}

import (
	"testing"
)

func TestSimple(t *testing.T) {
	got := 1
	want := 2
	if got != want {
		t.Fatalf("want %v, but %v:", want, got)
	}
}
{{_filter_:test}}
