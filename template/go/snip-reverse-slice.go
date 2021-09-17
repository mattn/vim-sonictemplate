func reverse(arr []{{_input_:type}}) {
    for i := len(arr)/2-1; i >= 0; i-- {
        j := len(arr)-1-i
        arr[i], arr[j] = arr[j], arr[i]
    }
}
