for (const {{_input_:key}} in {{_input_:object}}) {
	if ({{_input_:object}}.hasOwnProperty({{_input_:key}})) {
		const {{_input_:element}} = {{_input_:object}}[{{_input_:key}}];
		{{_cursor_}}
	}
}
