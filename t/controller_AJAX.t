use strict;
use warnings;
use Test::More;


use Catalyst::Test 'JakartaPM';
use JakartaPM::Controller::AJAX;

ok( request('/ajax')->is_success, 'Request should succeed' );
done_testing();
