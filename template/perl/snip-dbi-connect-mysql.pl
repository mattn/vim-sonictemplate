my $dbh = DBI->connect("dbi:mysql:{{_cursor_}}", "", "");
$dbh->disconnect;
