package JakartaPM::Schema::SiteDB::Result::Comment;
use Modern::Perl '2010';
use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 NAME

JakartaPM::Schema::SiteDB::Result::Comment

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<comment>

=cut

__PACKAGE__->table("comment");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 article_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 author_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 content

  data_type: 'text'
  is_nullable: 0

=head2 pub_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 modified_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 requires_moderation

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 moderator_deleted

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 response_to_comment

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "article_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "author_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "content",
  { data_type => "text", is_nullable => 0 },
  "pub_date",
  { data_type => "datetime", datetime_undef_if_invalid => 1, is_nullable => 0, },
  "modified_date",
  { data_type => "datetime", datetime_undef_if_invalid => 1, is_nullable => 1, },
  "requires_moderation",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "moderator_deleted",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "response_to_comment",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 article

Type: belongs_to

Related object: L<JakartaPM::Schema::SiteDB::Result::Article>

=cut

__PACKAGE__->belongs_to(
  "article",
  "JakartaPM::Schema::SiteDB::Result::Article",
  { id => "article_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 author

Type: belongs_to

Related object: L<JakartaPM::Schema::SiteDB::Result::User>

=cut

__PACKAGE__->belongs_to(
  "author",
  "JakartaPM::Schema::SiteDB::Result::User",
  { id => "author_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 comments

Type: has_many

Related object: L<JakartaPM::Schema::SiteDB::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "JakartaPM::Schema::SiteDB::Result::Comment",
  { "foreign.response_to_comment" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 response_to_comment

Type: belongs_to

Related object: L<JakartaPM::Schema::SiteDB::Result::Comment>

=cut

__PACKAGE__->belongs_to(
  "response_to_comment",
  "JakartaPM::Schema::SiteDB::Result::Comment",
  { id => "response_to_comment" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


__PACKAGE__->meta->make_immutable;
1;
