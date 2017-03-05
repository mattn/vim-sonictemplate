{{_define_:var:"new".substitute('{{_name_}}', '\w\+', '\u\0', '')}}
set {{_input_:name}}({{_var_:var}}) {
	this._{{_var_:name}} = {{_var_:var}};
}
{{_cursor_}}
