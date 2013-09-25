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
  default_value: 'id_ID'
  is_nullable: 0
  size: 5

=head2 uid

  data_type: 'varchar'
  is_nullable: 0
  size: 200

=head2 dtstamp

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 organizer_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 dtstart

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 dtend

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 summary

  data_type: 'text'
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "lang",
  {
    data_type => "varchar",
    default_value => "id_ID",
    is_nullable => 0,
    size => 5,
  },
  "uid",
  { data_type => "varchar", is_nullable => 0, size => 200 },
  "dtstamp",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "organizer_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "dtstart",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "dtend",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "summary",
  { data_type => "text", is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<uid_UNIQUE>

=over 4

=item * L</uid>

=back

=cut

__PACKAGE__->add_unique_constraint("uid_UNIQUE", ["uid"]);

=head1 RELATIONS

=head2 events_attending

Type: has_many

Related object: L<JakartaPM::Schema::SiteDB::Result::EventAttending>

=cut

__PACKAGE__->has_many(
  "events_attending",
  "JakartaPM::Schema::SiteDB::Result::EventAttending",
  { "foreign.event_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 organizer

Type: belongs_to

Related object: L<JakartaPM::Schema::SiteDB::Result::User>

=cut

__PACKAGE__->belongs_to(
  "organizer",
  "JakartaPM::Schema::SiteDB::Result::User",
  { id => "organizer_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 attendees

Type: many_to_many

Composing rels: L</events_attending> -> attendee

=cut

__PACKAGE__->many_to_many("attendees", "events_attending", "attendee");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-09-12 12:24:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:POJH4qMmSLEGg4wbTo/95g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
