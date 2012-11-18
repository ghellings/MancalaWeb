use strict;
use warnings;
use Test::More;


use Catalyst::Test 'MancalaWeb';
use MancalaWeb::Controller::Player;

ok( request('/player')->is_success, 'Request should succeed' );
done_testing();
