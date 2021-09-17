func find{{_cursor_}}(arr []{{_input_:type}}, v {{_input_:type}}) int {
    for i := 0; i < len(arr); i++ {
        if arr[i] == v {
            return i
        }
    }
    return -1
}
