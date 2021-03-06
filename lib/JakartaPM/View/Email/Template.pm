package JakartaPM::View::Email::Template;

use strict;
use base 'Catalyst::View::Email::Template';

__PACKAGE__->config(
    stash_key       => 'email',
    template_prefix => '',
    default => { view => 'Email::Wrapper' },
);

=head1 NAME

JakartaPM::View::Email::Template - Templated Email View for JakartaPM

=head1 DESCRIPTION

View for sending template-generated email from JakartaPM. 

=head1 AUTHOR

A clever guy

=head1 SEE ALSO

L<JakartaPM>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
