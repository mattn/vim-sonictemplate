app.Pots("/:api", func(c *fiber.Ctx) error {
	msg := c.Params("file"), c.Params("api")
	return c.SendString("{{_cursor_}}")
})
