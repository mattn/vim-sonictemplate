func reduceFunc{{_cursor_}}(a []{{_input_:type}}, f func(e1, e2 {{_input_:type}}) {{_input_:type}}, zero interface{}) {{_input_:type}} {
    if len(a) == 0 || f == nil {
        var vv {{_input_:type}}
        return vv
    }

    l := len(a) - 1

    rf := func(a []{{_input_:type}}, ff func({{_input_:type}}, {{_input_:type}}) {{_input_:type}}, memo {{_input_:type}}, startPoint, direction, length int) {{_input_:type}} {
        result := memo
        index := startPoint

        for i := 0; i <= length; i++ {
            result = ff(result, a[index])
            index += direction
        }

        return result
    }

    if zero == nil {
        return rf(a, f, a[0], 1, 1, l-1)
    }

    return rf(a, f, zero.({{_input_:type}}), 0, 1, l)
}
