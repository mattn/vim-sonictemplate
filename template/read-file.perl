open my $fh, '<', '{{_cursor}}' or die "failed to open: $!";
my $content = do { local $/; <$fh> };
