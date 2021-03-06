package JakartaPM::View::Email::Wrapper;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
    render_die => 1,
    wrapper => 'email/wrapper',
);

=head1 NAME

JakartaPM::View::Email::Wrapper - TT View for JakartaPM

=head1 DESCRIPTION

TT View for JakartaPM.

=head1 SEE ALSO

L<JakartaPM>

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
