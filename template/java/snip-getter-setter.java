/**
 * get {{_input_:name}}
 * @return {{_var_:name}}
 */
public {{_input_:type}} get{{_expr_:substitute('{{_var_:name}}', '\w\+', '\u\0', '')}}() {
	return {{_var_:name}};
}

/**
 * set {{_var_:name}}
 * @param {{_var_:name}}
 */
public void set{{_expr_:substitute('{{_var_:name}}', '\w\+', '\u\0', '')}}({{_var_:type}} {{_var_:name}}) {
	this.{{_var_:name}} = {{_var_:name}};
}
