func filterFunc(a []{{_input_:type}}, f func({{_input_:type}}) bool) []{{_input_:type}} {
    var n []{{_input_:type}}
    for _, e := range a {
        if f(e) {
            n = append(n, e)
        }
    }
    return n
}
