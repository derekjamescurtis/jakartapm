#!/usr/bin/env perl
use Modern::Perl '2010';
use Config::General qw(ParseConfig);
use FindBin qw/$RealBin/;
use Path::Class;
use lib dir($RealBin, '..', 'lib')->stringify;
use JakartaPM::Schema::SiteDB;


say 'Opening our config file.';

# legwork to setup things --> get a database connection
my $conf_filename   = file($RealBin, '..', 'jakartapm.conf');
my %cfg             = new Config::General(-ConfigFile => $conf_filename, -ApacheCompatible => 1)->getall;
my $schema          = JakartaPM::Schema::SiteDB->connect(@{$cfg{'Model::SiteDB'}->{connect_info}}) or die "Failed to connect to database"; 

print 'Preparing to deploy database...';

# Ok, cool.. now let's try to deploy our stuff
$schema->deploy();

say 'Done!';