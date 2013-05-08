/**
 * get {{_input_:name}}
 * @return {{_var_:name}}
 */
public {{_input_:type}} get{{_expr_:substitute('{{_var_:name}}', '\w\+', '\u\0', '')}}() {
	return {{_var_:name}};
}
