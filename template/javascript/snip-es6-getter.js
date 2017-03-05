{{_define_:var:"new".substitute('{{_name_}}', '\w\+', '\u\0', '')}}
get {{_input_:name}}() {
	return this._{{_var_:name}};
}
{{_cursor_}}
