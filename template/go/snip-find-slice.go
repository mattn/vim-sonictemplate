func find{{_cursor_}}(a []{{_input_:type}}, v {{_input_:type}}) int {
    for i := 0; i < len(a); i++ {
        if a[i] == v {
            return i
        }
    }
    return -1
}
