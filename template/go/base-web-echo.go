package main

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "{{_cursor_}}")
	})
	e.Logger.Fatal(e.Start(":8989"))
}
{{_filter_:web-echo}}
