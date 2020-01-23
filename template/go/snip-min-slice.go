func min(a []{{_input_:type}}) {{_input_:type}} {
	m := a[0]
	for _, v := range a {
		if v < m {
			m = v
		}
	}
	return m
}
