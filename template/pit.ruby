require "pit"

config = Pit.get("{{_input_:domain}}", :require => {
	"username" => "username of {{_input_:domain}}",
	"password" => "password of {{_input_:domain}}",
})
{{_cursor_}}
