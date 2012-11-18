use strict;
use warnings;
use Test::More;


use Catalyst::Test 'MancalaWeb';
use MancalaWeb::Controller::Game;

ok( request('/game')->is_success, 'Request should succeed' );
done_testing();
