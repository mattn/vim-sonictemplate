use Config::Pit;

my $config = pit_get("{{_input_:domain}}", require => {
	"username" => "username of {{_var_:domain}}",
	"password" => "password of {{_var_:domain}}",
});
{{_cursor_}}
