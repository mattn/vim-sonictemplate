use v6;
unit class {{_var_:package}};

=begin pod

=head1 NAME

{{_expr_:substitute(substitute(expand('%:r'), '.*lib[\\/]', '', 'g'), '[\\/]', '::', 'g')}} - blah blah blah

=head1 SYNOPSIS

  use {{_var_:package}};

=head1 DESCRIPTION

{{_var_:package}} is ...

=head1 COPYRIGHT AND LICENSE

Copyright {{_expr_:strftime("%Y")}} {{_expr_:get(g:, "sonictemplate_user_email", filter([$USER, $UESRNAME, "No Name <noname@example.com>"], "len(v:val)>0")[0])}}

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
{{_define_:package:substitute(substitute(expand('%:r'), '.*lib[\\/]', '', 'g'), '[\\/]', '::', 'g')}};
