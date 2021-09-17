func shuffle{{_cursor_}}(a []{{_input_:tpe}}) {
    for i := len(a) - 1; i > 0; i-- {
        j := rand.Intn(i + 1)
        a[i], a[j] = a[j], a[i]
    }
}
