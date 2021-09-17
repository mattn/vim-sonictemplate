func deleteValue(a []{{_input_:type}}, v {{_input_:type}}) []{{_input_:type}} {
    r := make([]{{_input_:type}}, len(a))
    for i := 0; i < len(a); i++ {
        if a[i] != v {
            r = append(r, a[i])
        }
    }
    return r
}
