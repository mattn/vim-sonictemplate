func reverse{{_cursor_}}(a []{{_input_:type}}) {
    for i := len(a)/2-1; i >= 0; i-- {
        j := len(a)-1-i
        a[i], a[j] = a[j], a[i]
    }
}
