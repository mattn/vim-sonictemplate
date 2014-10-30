func ({{_var_:varname}} {{_var_:name}}) Len() int {
	return len({{_var_:varname}})
}

func ({{_var_:varname}} {{_var_:name}}) Less(i, j int) bool {
	return {{_var_:varname}}[i] < {{_var_:varname}}[j]
}

func ({{_var_:varname}} {{_var_:name}}) Swap(i, j int) {
	{{_var_:varname}}[i], {{_var_:varname}}[j] = {{_var_:varname}}[j], {{_var_:varname}}[i]
}
{{_define_:name:input('name: ')}}
{{_define_:varname:substitute('{{_var_:name}}' =~ '^[ij]' ? '{{_var_:name}}'[:1] : '{{_var_:name}}'[0],'\w\+', '\l\0', '')}}
