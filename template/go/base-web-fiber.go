package main

import (
	"github.com/gofiber/fiber/v2"
)

func main() {
	app := fiber.New()

	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendString("{{cursor_}}")
	})

	app.Listen(":8989")
}
{{_filter_:web-fiber}}
