defer func() {
	if recover() != nil {
		{{_cursor_}}
	}
}()
