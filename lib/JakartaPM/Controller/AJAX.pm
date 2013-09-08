package JakartaPM::Controller::AJAX;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

JakartaPM::Controller::AJAX - Catalyst Controller

=head1 DESCRIPTION

A single controller to handle all of our AJAX requests.  
We do this because this gives us an easier way to control the processing chain.

Event though we call this controller our AJAX controller, it's really performing
all of our ASYNC processing.  AJAX (although a complete misnomer) is more likely
to convey what this controller does just by it's name than calling it something
else. 

=head1 METHODS

=cut


=head2 get_provinces_json

Gets a json-encoded list of provinces for a given two digit country code.

=cut

sub get_provinces_json {
    my ( $self, $c ) = @_;
}






=head2 end



=cut
sub end :ActionClass('RenderView') {
    my ($self, $c) = @_;
    
    $c->forward($c->view('AJAX')) unless $c->response->body;    
}

=encoding utf8

=head1 AUTHOR

Derek J. Curtis <djcurtis@summersetsoftware.com>
Summerset Software, LLC
http://www.summersetsoftware.com

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
