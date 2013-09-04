use strict;
use warnings;
use Test::More;


use Catalyst::Test 'JakartaPM';
use JakartaPM::Controller::News;

ok( request('/news')->is_success, 'Request should succeed' );
done_testing();
