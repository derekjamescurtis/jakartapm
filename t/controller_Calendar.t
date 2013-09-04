use strict;
use warnings;
use Test::More;


use Catalyst::Test 'JakartaPM';
use JakartaPM::Controller::Calendar;

ok( request('/calendar')->is_success, 'Request should succeed' );
done_testing();
