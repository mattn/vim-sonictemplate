package main

import (
    "fmt"
    "net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "{{_cursor_}}")
	})
	http.ListenAndServe(":8080", nil)
}
{{_filter_:web-standard}}
