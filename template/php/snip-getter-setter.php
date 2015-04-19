/**
 * Get {{_input_:property}}
 *
 * @return {{_input_:type}}
 */
public function get{{_expr_:substitute('{{_var_:property}}', '\w\+', '\u\0', '')}}() {
	return $this->{{_var_:property}};
}

/**
 * Set {{_var_:property}}
 *
 * @param {{_var_:type}} {{_var_:property}}
 */
public function set{{_expr_:substitute('{{_var_:property}}', '\w\+', '\u\0', '')}}(${{_var_:property}}) {
	$this->{{_var_:property}} = ${{_var_:property}};
}
