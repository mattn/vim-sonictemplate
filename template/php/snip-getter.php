/**
 * Get {{_input_:property}}
 *
 * @return {{_input_:type}}
 */
public function get{{_expr_:substitute('{{_var_:property}}', '\w\+', '\u\0', '')}}() {
	return $this->{{_var_:property}};
}
