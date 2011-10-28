my $dbh = DBI->connect("dbi:SQLite:dbname={{_cursor_}}");
$dbh->disconnect;
