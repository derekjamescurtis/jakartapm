use utf8;
package JakartaPM::Schema::SiteDB::Result::Article;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

JakartaPM::Schema::SiteDB::Result::Article

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

=head1 TABLE: C<article>

=cut

__PACKAGE__->table("article");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 lang

  data_type: 'varchar'
  is_nullable: 0
  size: 5

=head2 content

  data_type: 'text'
  is_nullable: 1

=head2 author_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 pub_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 modified_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 is_locked

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 slug

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "lang",
  { data_type => "varchar", is_nullable => 0, size => 5 },
  "content",
  { data_type => "text", is_nullable => 1 },
  "author_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "pub_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "modified_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "is_locked",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "slug",
  { data_type => "varchar", is_nullable => 0, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<slug_UNIQUE>

=over 4

=item * L</slug>

=back

=cut

__PACKAGE__->add_unique_constraint("slug_UNIQUE", ["slug"]);

=head1 RELATIONS

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
  { "foreign.article_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-09-09 09:49:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6bI8aWkKXLzxugP0eMIEvg



# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
