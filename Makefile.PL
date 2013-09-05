#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'JakartaPM';
all_from 'lib/JakartaPM.pm';

# standard includes
requires 'Catalyst::Runtime' => '5.90042';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::General';

# required specifically for our app
requires 'Catalyst::View::TT' => '0.41';
requires 'Email::Valid' => '0.190';

# First is the driver to connect to our chosen database.  The second is used to regenerate our model classes if we change the schema
requires 'DBD::mysql' => '4.023';
requires 'Catalyst::Model::DBIC::Schema' => '0.61';

# web forms (don't code your own!)
requires 'HTML::FormHandler' => '0.40027';

# session handling
# There are many different plugins that will all give you session support. 
# I tend to prefer this method as it's very easy to configure and gives relatively
# good performance.
requires 'Catalyst::Plugin::Session' => '0.37';
requires 'Catalyst::Plugin::Session::Store::FastMmap' => '0.15';
requires 'Catalyst::Plugin::Session::State::Cookie' => '0.17';

# transparent unicode support
requires 'Catalyst::Plugin::Unicode::Encoding' => '2.1';

# For the most part, if you have full access to the web server your application is running on, you can
# set this up at the web server level.  In instances where you cannot, I show this module as a demonstration of how SSL can be enforced  
requires 'Catalyst::Plugin::RequireSSL' => '0.07';

# authentication-related
requires 'Catalyst::Plugin::Authentication' => '0.10023';
requires 'Catalyst::Plugin::Authorization::Roles' => '0.09';
requires 'Catalyst::Plugin::Authentication::Store::DBIx::Class' => '0.1505';
requires 'Crypt::SaltedHash' => '0.09';

test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
