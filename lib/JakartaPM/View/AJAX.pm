package JakartaPM::View::AJAX;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

=head1 NAME

JakartaPM::View::AJAX - Catalyst View

=head1 DESCRIPTION

Catalyst View.

=cut

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
    CATALYST_VAR => 'c', # this defaults to c anyway, so it doesn't need to be explitially set
    render_die  => 1,
);

=head1 NAME

JakartaPM::View::AJAX - TT View for JakartaPM

=head1 DESCRIPTION

TT View for JakartaPM.

=head1 SEE ALSO

L<JakartaPM>

=head1 AUTHOR

Derek J. Curtis <djcurtis@summersetsoftware.com>
Summerset Software, LLC
http://www.summersetsoftware.com

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

