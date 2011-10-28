open my $fh, '<', '{{_cursor_}}' or die "failed to open: $!";
my $content = do { local $/; <$fh> };
