use strict;
use ExtUtils::MakeMaker;

my %clean = (
    'FILES' => '$(DISTVNAME).tar$(SUFFIX) *.ppd'
);

my %dist = (
    PREOP => 'perldoc -t {{_define_:modulepm:(split(substitute(glob("lib/*.pm"),"\\","/","g"),"\n")+[''])[0]}} > README',
);

WriteMakefile(
    'NAME'          => '{{_expr_:fnamemodify(sonictemplate#getvar("modulepm"),":t:r")}}',
    'AUTHOR'        => 'Your Name <you@cpan.org>',
    'ABSTRACT_FROM' => '{{_var_:modulepm}}',
    'VERSION_FROM'  => '{{_var_:modulepm}}',
    'clean'         => \%clean,
    'dist'          => \%dist,
);
