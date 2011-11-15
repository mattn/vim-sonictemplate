my $dbh = DBI->connect("dbi:Oracle:{{_cursor_}}", "", "");
$dbh->disconnect;
