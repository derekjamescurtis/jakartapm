use strict;
use warnings;
use FindBin qw/ $RealBin /;
use Path::Class;
use lib dir($RealBin, 'lib')->stringify;
use JakartaPM;

my $app = JakartaPM->apply_default_middlewares(JakartaPM->psgi_app);
$app;

