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
next appended that will be used to return the user to this current action
 
=cut
sub login_required :Chained('/') :PathPart('') :CaptureArgs(0) {
    my ($self, $c) = @_;
    
    unless ($c->user_exists) {
        
        my $next_uri    = $c->uri_for($c->action);          
        my $login_action= $c->controller->action_for('login');
        
        my $login_uri   = $c->uri_for($login_action, { next => $next_uri });
        
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

Very simple method that just logs the current user out of the system, then returns them
to the index page.

=cut
sub logout :Chained('login_required') :PathPart('logout') :Args(0) {
    my ($self, $c) = @_;
    
    $c->logout;
    
    my $root_uri = $c->uri_for($c->controller('Root')->action_for('index'));
    
    $c->response->redirect($root_uri);
    $c->detach();
}



=head2 anon_required

Base of the processing chain for any actions that require the user NOT be logged in.

Just does a simple check to see if the user is logged in already.. if they are, we log
them out and push them back to the homepage.  

=cut
sub anon_required :Chained('/') :PathPart('') :CaptureArgs(0) {
    my ($self, $c) = @_;
    
    if ($c->user_exists) {
        
        $c->flash->{error_msg} = 'Sorry.  You can\'t access this page while logged in.';
        
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
            
            $f->process(params => $c->req->body_params);
            if ($f->validated) {
                # make sure their username + email is unique
                # we could do that in the forms, but in a non-dbixclass i can't think of an easy way to do that..
                # this validation should really go in our forms class though
                
                # now we can create their new user object 
                
                # send confirmation e-mail
                $c->flash->{status_msg} = "woo.. validated new user";
                
            }
            else{
                $c->flash->{error_msg} = 'poopie.. new validation failed';
            }
            
        }
        else {
            # Trying to log into existing account.
            $f->process( params => $c->req->body_params, inactive => [ 'password_confirm', 'email', ] );                
            if ($f->validated) {

                $c->authenticate({ username => $f->value->{username}, password => $f->value->{password} });
                
                # now see if the user actually auth'd
                if ($c->user_exists) {
                    
                    # also, make sure their account is in good standing (and they've confirmed their e-mail)
                    if (!$c->user->get('is_active')) {
                        $c->flash->{error_msg} = 
                            "Hey, I'm really sorry, but your account has been disabled by my administrator.  " . 
                            "You did something bad, didn't you?  =/  Maybe if you use the 'Contact Us' form and " .
                            "send my administrator an e-mail and tell them you're REALLY sorry, they'll reinstate " .
                            "your account.";                            
                        $c->logout;
                    }
                    elsif (!$c->user->get('confirmation_date')) {     
                        
                        my $resend_conf_uri = $c->uri_for($c->controller->action_for('confirm_email_resend'));                                         
                        $c->flash->{error_msg} = 
                            "Aw shoot dawg.. You didn't confirm your e-mail address yet!  You know, we gotta watch " .
                            "out for dem bots.. Hey, but if for some reason you can't find your confirmation e-mail " . 
                            "(remember to check your Spam folder!).  We can always get you another one!  " . 
                            "Just click <a href='${resend_conf_uri}'>here</a>.";                            
                        $c->logout;
                    } 
                    else {
                        # cool!!! 
                        # there might be a 'next' query parameter that will be the URI they wanted..
                        # otherwise, just shoot them back to the site root
                        my $next_uri = $c->req->query_params->{next} || $c->uri_for($c->controller('Root')->action_for('index'));
                        
                        $c->response->redirect($next_uri);
                    }                    
                }
                else {                    
                    # bad username/password..
                    my $pwd_reset_uri = $c->uri_for($c->controller->action_for('password_reset_request'));                    
                    $c->flash->{error_msg} = 
                        "Sorry, I don't recognize that username or password combination.  " .
                        "If you're having trouble, you can reset your password from " . 
                        "<a href='${pwd_reset_uri}'>this</a> page.";
                }
                
            }
            else {
                # todo: get the actual form error message
                $c->flash->{error_msg} = 'Oh snap, there was a problem with the form you submitted.  Please verify and try again.';
            }   
        }        
        # todo: if we get to this point, i think we're just going to need to recreate the form instance
        
    }
    

    $c->stash->{form} = $f;    
    
}

sub register :Chained('anon_required') :PathPart('register') :Args(0) {
    
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
