use strict;
use warnings;

use JakartaPM;

my $app = JakartaPM->apply_default_middlewares(JakartaPM->psgi_app);
$app;

