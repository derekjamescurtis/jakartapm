package JakartaPM::Controller::AJAX;
use Moose;
use namespace::autoclean;
use JakartaPM::Forms::Contact;

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

sub contact_form :Path('contact') :Args(0) {
    my ($self, $c) = @_;
    
    my $f = JakartaPM::Forms::Contact->new();
    
    if ($c->request->method eq 'POST') {
        
        my $result = $f->run( $c->request->body_parameters );
        
        if ($result->validated) {            
            $c->response->body('Great! Everything worked like a fucking charm! =D');
            $c->response->status(200);
        }
        else {
            # todo: get the ACTUAL error messages here
            # todo: return a better HTTP response
            $c->response->body('Ooops.. something went wrong');
            $c->response->status(500);
        }
        
    }
    else {
        # get requests always want a new form        
        
        # TODO: if the user is logged in, then we want to manually specify some of the field (like their name and email address)
        # and disable those on the form
            
        $c->stash->{form} = $f;
    }    
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
