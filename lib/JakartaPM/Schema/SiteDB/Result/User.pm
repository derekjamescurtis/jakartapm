use utf8;
package JakartaPM::Schema::SiteDB::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

JakartaPM::Schema::SiteDB::Result::User

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

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 password

  data_type: 'varchar'
  is_nullable: 0
  size: 500

=head2 email

  data_type: 'varchar'
  is_nullable: 0
  size: 254

=head2 roles

  data_type: 'varchar'
  is_nullable: 0
  size: 500

=head2 internal_notes

  data_type: 'text'
  is_nullable: 1

=head2 is_active

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 0

=head2 confirmation_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 confirmation_key

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 reset_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 reset_key

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 about_me

  data_type: 'text'
  is_nullable: 1

=head2 city

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 province

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 country

  data_type: 'varchar'
  is_nullable: 1
  size: 3

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "username",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "password",
  { data_type => "varchar", is_nullable => 0, size => 500 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 254 },
  "roles",
  { data_type => "varchar", is_nullable => 0, size => 500 },
  "internal_notes",
  { data_type => "text", is_nullable => 1 },
  "is_active",
  { data_type => "tinyint", default_value => 1, is_nullable => 0 },
  "confirmation_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "confirmation_key",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "reset_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "reset_key",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "about_me",
  { data_type => "text", is_nullable => 1 },
  "city",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "province",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "country",
  { data_type => "varchar", is_nullable => 1, size => 3 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<confirmation_key_UNIQUE>

=over 4

=item * L</confirmation_key>

=back

=cut

__PACKAGE__->add_unique_constraint("confirmation_key_UNIQUE", ["confirmation_key"]);

=head2 C<email_UNIQUE>

=over 4

=item * L</email>

=back

=cut

__PACKAGE__->add_unique_constraint("email_UNIQUE", ["email"]);

=head2 C<reset_key_UNIQUE>

=over 4

=item * L</reset_key>

=back

=cut

__PACKAGE__->add_unique_constraint("reset_key_UNIQUE", ["reset_key"]);

=head2 C<username_UNIQUE>

=over 4

=item * L</username>

=back

=cut

__PACKAGE__->add_unique_constraint("username_UNIQUE", ["username"]);

=head1 RELATIONS

=head2 articles

Type: has_many

Related object: L<JakartaPM::Schema::SiteDB::Result::Article>

=cut

__PACKAGE__->has_many(
  "articles",
  "JakartaPM::Schema::SiteDB::Result::Article",
  { "foreign.author_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 comments

Type: has_many

Related object: L<JakartaPM::Schema::SiteDB::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "JakartaPM::Schema::SiteDB::Result::Comment",
  { "foreign.author_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-09-05 03:13:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vF1j2oD3UFId5rbK7/24Jw

use Carp;
use Data::Dumper;


=head1 CLASS METHODS
=cut

=head2 create_user(username, password, email)
=cut
sub create_user {
    my %args = @_;
    
    # make sure we have all the parameters we're looking for
    my ($un, $pwd, $email) = ($args{username}, $args{password}, $args{email});
    unless ($un && $pwd && $email) {
        carp "username, password and email are all required named parameters.\nArgs received:\n " . Dumper(%args);
        return undef;    
    }
    
    
    # make sure that e-mail is valid, username meets requirements.  
    # We'll assume that the password has been validated to meet 
    # strenght requirements 
    # TODO: we should really perform validation here again. 
    
    # username, e-mail address, password
    
    
    
}

=head2 create_superuser()

Similar to the create_user method, but this user does not have to verify their e-mail
address as it's assumed that this user is fully trusted.

=cut
sub create_superuser {
    my %args = @_;
}

=head2 set_password

=cut
sub set_password {
    my $self = shift;
    my %args = @_;
    
    
    
    
}

=head2 generate_confirmation_key()

=cut
sub generate_confirmation_key {
    my $self = shift;
}


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
