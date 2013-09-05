package JakartaPM::Controller::Members;
use Moose;
use namespace::autoclean;
use JakartaPM::Forms::LoginRegister;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

JakartaPM::Controller::Members - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 AUTHENTICATION REQUIRED METHODS

The following methods all required that the user is authenticated.  

This demonstrates the use of 'chained' actions.  For example, when a user requests
the url /profile/edit, catalyst resolves that sub routined, but because it's chained to 'login_required'
that subroutine will be executed first.  You can have an arbitrary number of subroutines chained to one another.
The various :PathPart attributes will all be concatinated together.  

If they are not,they will be redirected to the login page.  A next=url query string will be appended

=head2 login_required()
 
The start of the processing chain for any actions that require a user to be logged in.  
If the user is not logged in, they will be redirected to the login form, with a query parameter
next appended.
 
=cut
sub login_required :Chained('/') :PathPart('') :CaptureArgs(0) {
    my ($self, $c) = @_;
    
    # user exists returns a true/false value if a user is currently logged in
    if (!$c->user_exists) {
        
        # find the uri for the login action in this controller 
        # then we add a hash reference that contains our return url
        # this is because after the user authenticates, we want to automatically be able to send
        # them back to whichever page they were trying to view         
        my $login_uri = $c->uri_for($c->controller('Members')->action_for('login'), { next => $c->action });
        
        # in most cases, when we call catalyst's redirect method, we must ALSO 
        # immediately afterwards call the detach method (with no arguments).
        # this is because redirect does NOT halt processing on the rest of chain (including rendering a template)
        # response->redirect only writes the redirect header to our response object.  Detach stops
        # any further processing at this point. 
        $c->response->redirect($login_uri);
        $c->detach();
    } 
    
}

=head2 edit_profile
=cut
sub edit_profile :Chained('login_required') :PathPart('profile/edit') :CaptureArgs(0) {
    my ($self, $c) = @_;
}

=head2 
=cut
sub logout :Chained('login_required') :PathPart('logout') :Args(0) {
    my ($self, $c) = @_;
}



=head2
=cut
sub anon_required :Chained('/') :PathPart('') :CaptureArgs(0) {
    my ($self, $c) = @_;
    
    # if the user exists.. then we push them back to an arbitrary page
    # let's say, the start page, and tell them unfortunately they can't visit
    # whichever page they were trying to get to
    if ($c->user_exists) {
        $c->set_error_message('Sorry.  You can\'t access this page while logged in.');
        
        # when resolving a uri that's outside the current controller, we have a slightly more verbose syntax
        # than we saw in the login_required method earlier
        my $site_root_uri = $c->uri_for($c->controller('Root')->action_for('index'));
                
        $c->response->redirect($site_root_uri);
        $c->detach();
        
    }
}

=head2 

Displays a login form to a user.  On POST attempts to authenticate the user's credentials
and makes sure their account is active and their e-mail address has been confirmed.  

This is actually a two part form that allows the user to either login with an existing account
or to create a new account.

=cut
sub login :Chained('anon_required') :PathPart('login') :Args(0){
    my ($self, $c) = @_;
    
    my $f = JakartaPM::Forms::LoginRegister->new();
    
    if ($c->request->method eq 'POST') {
        
        if($c->request->body_params->{new_or_existing} eq 'new'){
            # they're trying to register a new account
            
            
            # make sure their username + email is unique
            # we could do that in the forms, but in a non-dbixclass i can't think of an easy way to do that..
            # this validation should really go in our forms class though
            
        }
        else {
            # they're trying to log into an existing account
            
            # set fields to be inactive
            # $form->process( inactive => ['foo'] );
            
            
        }
        
    }
    
    


    $c->stash->{form} = $f;    
    
    
}


sub confirm_email_resend :Chained('anon_required') :PathPart('email/confirm/resend') :Args(0) {
    my ($self, $c) = @_;
}

sub confirm_email :Chained('anon_required') :PathPart('email/confirm') :Args(1) {
    my ($self, $c, $confirm_key) = @_;
}


sub password_reset_request :Chained('anon_required') :PathPart('password/reset') :Args(0) {
    my ($self, $c) = @_;
}

sub password_reset_confirm :Chained('anon_required') :PathPart('password/reset') :Args(1) {
    my ($self, $c, $reset_key) = @_;
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
