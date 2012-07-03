use strict;
use warnings;
use Plack::Builder;
use Plack::Request;

my $app = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);
    return root($req) if $req->path eq '/';
    [ 404, [ "Content-Type" => "text/plain" ], ["Not Found"] ];
};

sub root {
    my $req = shift;
    my $res = $req->new_response(200);
    $res->content_type('text/html');
    $res->body('hello world');
    $res->finalize();
}

builder {
    enable "Plack::Middleware::Static", path => qr/static/, root => '.';
    $app;
};
