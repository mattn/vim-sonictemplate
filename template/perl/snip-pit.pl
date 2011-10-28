use Config::Pit;

my $config = pit_get("{{_input_:domain}}", require => {
	"username" => "username of {{_input_:domain}}",
	"password" => "password of {{_input_:domain}}",
});
{{_cursor_}}
