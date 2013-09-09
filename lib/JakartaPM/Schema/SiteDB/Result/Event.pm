use utf8;
package JakartaPM::Schema::SiteDB::Result::Event;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

JakartaPM::Schema::SiteDB::Result::Event

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<event>

=cut

__PACKAGE__->table("event");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 lang

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 uid

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 dtstamp

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 organizer_id

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 dtstart

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 dtend

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 summary

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "lang",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "uid",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "dtstamp",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "organizer_id",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "dtstart",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "dtend",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "summary",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-09-09 09:49:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:A9xKijWhUO5Pn4N7Tlclww


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
