func Test{{_cursor_}}(t *testing.T) {
	value := 1
	expected := 2
	if value != expected {
		t.Fatalf("Expected %v, but %d:", value, expected)
	}
}
