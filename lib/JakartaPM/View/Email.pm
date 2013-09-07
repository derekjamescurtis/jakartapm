package JakartaPM::View::Email;

use strict;
use base 'Catalyst::View::Email';

__PACKAGE__->config(
    stash_key => 'email'
);

=head1 NAME

JakartaPM::View::Email - Email View for JakartaPM

=head1 DESCRIPTION

View for sending email from JakartaPM. 

=head1 AUTHOR

A clever guy

=head1 SEE ALSO

L<JakartaPM>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
