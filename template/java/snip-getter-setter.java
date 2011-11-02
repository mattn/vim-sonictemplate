/**
 * get {{_input_:name}}
 * @return {{_input_:name}}
 */
public {{_input_:type}} get{{_expr_:substitute('{{_input_:name}}', '\w\+', '\u\0', '')}}() {
	return {{_input_:name}};
}

/**
 * set {{_input_:name}}
 * @param {{_input_:name}}
 */
public void set{{_expr_:substitute('{{_input_:name}}', '\w\+', '\u\0', '')}}({{_input_:type}} {{_input_:name}}) {
	this.{{_input_:name}} = {{_input_:name}};
}
