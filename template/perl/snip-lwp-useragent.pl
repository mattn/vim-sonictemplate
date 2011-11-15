my $ua = LWP::UserAgent->new;
$ua->env_proxy;
my $res = $ua->get("{{_cursor_}}");
