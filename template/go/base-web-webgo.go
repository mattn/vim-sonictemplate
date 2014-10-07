package main

import (
    "github.com/hoisie/web"
)

func main() {
	web.Get("/", func() string {
		return "{{_cursor_}}"
	})
	web.Run(":8080")
}
{{_filter_:web-webgo}}
