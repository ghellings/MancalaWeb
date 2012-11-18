use strict;
use warnings;

use MancalaWeb;

my $app = MancalaWeb->apply_default_middlewares(MancalaWeb->psgi_app);
$app;

