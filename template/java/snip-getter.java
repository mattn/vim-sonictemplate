/**
 * get {{_input_:name}}
 * @return {{_input_:name}}
 */
public {{_input_:type}} get{{_expr_:substitute('{{_input_:name}}', '\w\+', '\u\0', '')}}() {
	return {{_input_:name}};
}
