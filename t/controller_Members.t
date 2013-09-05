use strict;
use warnings;
use Test::More;


use Catalyst::Test 'JakartaPM';
use JakartaPM::Controller::Members;

ok( request('/members')->is_success, 'Request should succeed' );
done_testing();
