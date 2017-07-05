package main

import (
	"github.com/get-ion/ion"
	"github.com/get-ion/ion/context"
)

func main() {
	app := ion.New()
	app.Handle("GET", "/", func(ctx context.Context) {
		ctx.HTML("{{_cursor_}}")
	})
	app.Run(ion.Addr(":8080"))
}
