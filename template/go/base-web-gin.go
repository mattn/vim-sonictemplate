package main

import (
	"github.com/gin-gonic/gin"
	"github.com/mattn/go-colorable"
)

func main() {
	gin.DefaultWriter = colorable.NewColorableStderr()
	r := gin.Default()
	r.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "{{_cursor_}}",
		})
	})
	r.Run()
}
