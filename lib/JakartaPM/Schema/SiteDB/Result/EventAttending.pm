package JakartaPM::Schema::SiteDB::Result::EventAttending;
use Modern::Perl '2010';
use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';


=head1 NAME

JakartaPM::Schema::SiteDB::Result::EventAttending

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<event_attending>

=cut

__PACKAGE__->table("event_attending");

=head1 ACCESSORS

=head2 event_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 attendee_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "event_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "attendee_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</event_id>

=item * L</attendee_id>

=back

=cut

__PACKAGE__->set_primary_key("event_id", "attendee_id");

=head1 RELATIONS

=head2 attendee

Type: belongs_to

Related object: L<JakartaPM::Schema::SiteDB::Result::User>

=cut

__PACKAGE__->belongs_to(
  "attendee",
  "JakartaPM::Schema::SiteDB::Result::User",
  { id => "attendee_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 event

Type: belongs_to

Related object: L<JakartaPM::Schema::SiteDB::Result::Event>

=cut

__PACKAGE__->belongs_to(
  "event",
  "JakartaPM::Schema::SiteDB::Result::Event",
  { id => "event_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


__PACKAGE__->meta->make_immutable;
1;
