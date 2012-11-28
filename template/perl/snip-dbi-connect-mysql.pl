my $dbh = DBI->connect("dbi:mysql:{{_cursor_}}", "", "");
$dbh->disconnect;
{{_filter_:dbi}}
