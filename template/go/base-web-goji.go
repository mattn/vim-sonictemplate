package main

import (
	"net/http"

	"github.com/zenazn/goji"
	"github.com/zenazn/goji/web"
)

func main() {
	goji.Get("/", func(c web.C, w http.ResponseWriter, r *http.Request) {
		{{_cursor_}}
	})
	goji.Serve()
}
{{_filter_:web-goji}}
