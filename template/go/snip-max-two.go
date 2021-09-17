func max{{_cursor_}}(a, b {{_input_:type}}) {{_input_:type}} {
	if a > b {
		return a
	}
	return b
}
