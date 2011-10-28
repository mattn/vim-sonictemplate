my $sth = $dbh->prepare("{{_cursor_}}");
$sth->execute;
while (my @row = $sth->fetchrow_array) {
	#print join(', ', @row), "\n";
}
