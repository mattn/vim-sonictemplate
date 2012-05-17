std::for_each({{_input_:variable}}.begin(), {{_input_:variable}}.end(), [&](decltype({{_input_:variable}})::value_type x) {
	{{_cursor_}}
});
