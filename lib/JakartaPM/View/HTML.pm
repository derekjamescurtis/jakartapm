package JakartaPM::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
    CATALYST_VAR => 'c', # this defaults to c anyway, so it doesn't need to be explitially set
    render_die  => 1,
    WRAPPER     => 'common/wrapper',
    ERROR       => 'error.tt2',
    TIMER       => 1, # a debugging feature that will put 
    PRE_CHOMP   => 1, # remove newlines before template tags
    POST_CHOMP  => 1, # remove newlines after template tags 
);

=head1 NAME

JakartaPM::View::HTML - TT View for JakartaPM

=head1 DESCRIPTION

TT View for JakartaPM.

=head1 SEE ALSO

L<JakartaPM>

=head1 AUTHOR

Derek J. Curtis <djcurtis@summersetsoftware.com>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
