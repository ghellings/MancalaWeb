use strict;
use warnings;

use view;

my $app = view->apply_default_middlewares(view->psgi_app);
$app;

