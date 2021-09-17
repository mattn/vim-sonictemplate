func deleteIndex(a []{{_input_:type}}, i int) []{{_input_:type}} {
    var z {{_input_:type}}
    copy(a[i:], a[i+1:])
    a[len(a)-1] = z
    return a[:len(a)-1]
}
