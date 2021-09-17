func mapFunc{{_cursor_}}(a []{{_input_:type_from}}, f func({{_input_:type_from}}) {{_input_:type_to}}) []{{_input_:type_to}} {
    n := make([]{{_input_:type_to}}, len(a), cap(a))
    for i, e := range a {
        n[i] = f(e)
    }
    return n
}
