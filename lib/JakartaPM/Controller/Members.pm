package JakartaPM::Controller::Members;
use Moose;
use namespace::autoclean;
use JakartaPM::Forms::Login;
use JakartaPM::Forms::Register;
use JakartaPM::Forms::EmailConfirmResend;
use JakartaPM::Forms::PasswordReset;
use JakartaPM::Forms::PasswordResetConfirm;
use JakartaPM::Forms::Profile;


BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

JakartaPM::Controller::Members - Catalyst Controller

=head1 DESCRIPTION

Controller that handles user authentication, registration, and allows site users to preform other membership-related
functions like password resets/changes, changing their account profile and viewing other user's public profiles. 

There are two main processing chains that actions flow through.  The first chain is all the authentication-required 
actions, and the section are all the actions that require a user NOT be logged in (like registration, logging in, etc..).

There is at least one action which is not part of either chain ('view_public_profile'), because it has no requirements
one way or another about the user's current authentication state.

=head1 AUTHENTICATION REQUIRED CHAIN

The following methods all required that the user is authenticated.  

If they are not,they will be redirected to the login page.  A next=url query string will be appended,
which will be used to return them back to wherever they were trying to get before they needed to 
authenticate.

=head2 login_required()
 
The start of the processing chain for any actions that require a user to be logged in.  
If the user is not logged in, they will be redirected to the login form, with a query parameter
next appended that will be used to return the user to this current action
 
=cut

sub login_required :Chained('/') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    
    unless ($c->user_exists) {
        
        my $next_uri    = $c->uri_for($c->action);                  
        my $login_action= $c->controller('Members')->action_for('login');        
        my $login_uri   = $c->uri_for($login_action, { next => $next_uri });
        
        $c->res->redirect( $login_uri );
        $c->detach();
    } 
    
}

=head2 edit_profile

=cut

sub edit_profile :Chained('login_required') :PathPart('profile/edit') :Args(0) {
    my ( $self, $c ) = @_;
    
    my $u = $c->user->get_object;    
    my $f = JakartaPM::Forms::Profile->new(item => $u);    
    
    if ( $c->req->method eq 'POST' ) {
        $f->process( params => $c->req->body_params );
        
        if ($f->validated) {
            $c->flash( status_msg => 'Profile updated!' );
        }
        else {
            $c->flash( error_msg => 'There were some errors with the information you provided.  Please recheck.' );
        }        
    }
    
    $c->stash( form => $f );    
}

=head2 

Very simple method that just logs the current user out of the system, then returns them
to the index page.

=cut

sub logout :Chained('login_required') :PathPart('logout') :Args(0) {
    my ( $self, $c ) = @_;
    
    $c->logout;
    
    my $root_uri = $c->uri_for( $c->controller('Root')->action_for('index') );
    
    $c->res->redirect($root_uri);
    $c->detach();
}


=head1 ANON REQUIRED CHAIN

The following actions can only be visited by users who are NOT currently logged in.
This makes sense for things like registration pages, password reset pages, etc..

=head2 anon_required

Base of the processing chain for any actions that require the user NOT be logged in.

Just does a simple check to see if the user is logged in already.. If they are logged
in, we just push them back to the homepage and show them a simple message saying
'hey bro.. you can't go here.'

=cut

sub anon_required :Chained('/') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    
    if ($c->user_exists) {
        
        $c->flash( error_msg => 'Sorry.  You can\'t access this page while logged in.' );
        
        my $site_root_uri = $c->uri_for( $c->controller('Root')->action_for('index') );
                
        $c->res->redirect( $site_root_uri );
        $c->detach();        
    }
}

=head2 

Displays a login form to a user.  On POST attempts to authenticate the user's credentials
and makes sure their account is_active and their e-mail address has been confirmed.  

=cut

sub login :Chained('anon_required') :PathPart('login') :Args(0){
    my ( $self, $c ) = @_;
    
    my $f = JakartaPM::Forms::Login->new();
    
    if ($c->req->method eq 'POST') {

        $f->process( params => $c->req->body_params );                
        if ($f->validated) {

            $c->authenticate({ username => $f->value->{username}, password => $f->value->{password} });
            
            # now see if the user actually auth'd
            if ($c->user_exists) {
                
                if (!$c->user->get('is_active')) {
                    $c->flash->{error_msg} = 
                        "Hey, I'm really sorry, but your account has been disabled by my administrator.  " . 
                        "You did something bad, didn't you?  =/  Maybe if you use the 'Contact Us' form and " .
                        "send my administrator an e-mail and tell them you're REALLY sorry, they'll reinstate " .
                        "your account.";                            
                    $c->logout;
                }
                elsif (!$c->user->get('confirmation_date')) {     
                    
                    my $resend_conf_uri = $c->uri_for( $c->controller('Members')->action_for('confirm_email_resend') );                                         
                    $c->flash->{error_msg} = 
                        "Aw shoot dawg.. You didn't confirm your e-mail address yet!  You know, we gotta watch " .
                        "out for dem bots.. Hey, but if for some reason you can't find your confirmation e-mail " . 
                        "(remember to check your Spam folder!).  We can always get you another one!  " . 
                        "Just click <a href='${resend_conf_uri}'>here</a>.";                            
                    $c->logout;
                } 
                else {
                    
                    # great! they're logged in and their account is in good standing
                    # if the url has a query param named next, that should be a url that we need to redirect them to
                    # otherwise, just send them to the site root.
                    my $next_uri = $c->req->query_params->{next} || $c->uri_for( $c->controller('Root')->action_for('index') );                    
                    $c->res->redirect($next_uri);
                }                    
            } # end if user_exists
            else {                    
                # bad username/password..
                my $pwd_reset_uri = $c->uri_for( $c->controller('Members')->action_for('password_reset_request') );                    
                $c->flash( error_msg => 
                    "Sorry, I don't recognize that username or password combination.  " .
                    "If you're having trouble, you can reset your password from " . 
                    "<a href='${pwd_reset_uri}'>this</a> page.");
            }
            
        } # end if $f->validated
        else {
            $c->flash( error_msg => 'Oh snap, there was a problem with the form you submitted.  Please verify and try again.' );
        }           
    }

    $c->stash( form => $f );        
}


=head2 register

Displays a registration form to the user that prompts them for some basic information needed
to create a user account (username, email and password).  

On postback, if all their information validates, we create their new user object,
send them a confirmation e-mail, and redirect them back to the homepage with a short message
that tells them to go check their e-mail address.

=cut

sub register :Chained('anon_required') :PathPart('register') :Args(0) {
    my ( $self, $c ) = @_;
    
    my $f = JakartaPM::Forms::Register->new( catalyst => $c );
    
    if ( $c->req->method eq 'POST' ) {
        
        $f->process( params => $c->req->body_params );
        
        if ( $f->validated ) {
            
            # 1.) create the new user
            my $u = $c->model('SiteDB::User')->create({ 
               username     => $f->value->{username},
               email        => $f->value->{email},
               roles        => '',                        
            });            
            $u->set_password( password => $f->value->{password} );
            my $conf_key = $u->generate_confirmation_key;
            
            # 2.) send the validation e-mail
            my $conf_url = $c->uri_for( $c->controller('Members')->action_for('confirm_email'), [ $conf_key, ] );
            $c->stash(
                username => $f->value->{username},
                confirmation_uri => $conf_url,
                email => {
                    to      => $f->value->{email},
                    from    => $c->config->{'View::Email'}->{'default'}->{from},
                    subject => 'Jakarta.pm.org - Confirm Your E-mail',
                    template => 'confirm_email.tt2',
                },
            );
            $c->forward( $c->view('Email::Template') );            
            
            # 3.) add a confirmation message to the session and
            # redirect to the index page (message will be shown there)
            $c->flash( status_msg => 'Thanks for registering!  We\'ve sent you a confirmation e-mail, ' . 
                'so check your inbox (Pro Tip: If you don\'t see it, check your SPAM folder)!' );            
            my $root_uri = $c->uri_for( $c->controller('Root')->action_for('index') );
            $c->res->redirect( $root_uri );
            $c->detach();
        }
        else {
            # form didn't validate =(
            $c->flash( error_msg => 'UGH.. common bro!  Check your form data again.' );            
        }        
    }
    
    $c->stash( form => $f );    
}


=head2 confirm_email_resend

Shows the user a form that lets them enter their e-mail address to have their confirmation e-mail resent.
A new confirmation code will be generated (invalidating previous e-mails/conf keys).  If the user enters
an e-mail that doesn't exist, or is already confirmed, we don't tell them this.  We just tell them very
vaguely 'hey, we sent you another confirmation e-mail'!

=cut

sub confirm_email_resend :Chained('anon_required') :PathPart('email/confirm/resend') :Args(0) {
    my ($self, $c) = @_;
    
    my $f = JakartaPM::Forms::EmailConfirmResend->new();
    
    if ($c->req->method eq 'POST') {
        
        $f->process( params => $c->req->body_params );
        
        if ($f->validated) {
            
            my $u = $c->model('SiteDB::User')->find({ email => $f->value->{email} });
            
            if ($u && !$u->confirmation_date) {
                
                # invalidate previous confirmation key + send a new e-mail
                my $conf_key = $u->generate_confirmation_key;
                my $conf_url = $c->uri_for( $c->controller('Members')->action_for('confirm_email'), [ $conf_key, ] );                
                $c->stash(
                    username         => $u->username,
                    confirmation_uri => $conf_url,
                    email => {
                      to        => $u->email,
                      from      => $c->config->{'View::Email'}->{'default'}->{from},
                      subject   => 'Jakarta.pm.org - Confirm Your E-mail',
                      template  => 'confirm_email.tt2',  
                    },
                );
                $c->forward( $c->view('Email::Template') );
            }
            
            $c->flash( status_msg => 
                'Ok!  We sent you another confirmation e-mail (well, if we found your e-mail.. not gonna tell you ' . 
                'whether we did or didn\'t!).  Check your inbox, kthxbai? ');
            my $root_uri = $c->uri_for( $c->controller('Root')->action_for('index') );
            $c->res->redirect($root_uri);
            $c->detach();
        }
        else {
            $c->flash( error_msg => 'Hey, there was a problem with some of your form data.. fix it please =)' );
        }
    }
    
    $c->stash( form => $f );    
}


=head2 confirm_email

Tries to look up a confirmation key provided as part of the URL.  Normally, users should only get
here by following a link in the confirmation email sent out when they register their account.
After their account is confirmed (or not confirmed), they'll be redirected to the /login page.

URL: /email/confirm/{confirmation_key}

=cut

sub confirm_email :Chained('anon_required') :PathPart('email/confirm') :Args(1) {
    my ($self, $c, $confirm_key) = @_;
    
    my $u = $c->model('SiteDB::User')->find({ confirmation_key => $confirm_key });
    
    if (!defined $u) {
        $c->flash( error_msg => 'Hm.. Your confirmation key does not appear valid.' );        
    }
    elsif ($u->confirmation_date) {
        $c->flash( error_msg => 'That account has already been confirmed!  All you need to do is log in now!' );
    }
    else {                
        $u->update({ confirmation_date => DateTime->now });        
        $c->flash( status_msg => 'Ok!  Your account is confirmed!  All you need to do is log in!.' );
    }
    
    my $login_uri = $c->uri_for( $c->controller('Members')->action_for('login') );
    $c->res->redirect($login_uri);
    $c->detach();
    
}

=head2 password_reset_request

Allows the user to request a password reset link be set to their e-mail by 
providing their registration e-mail address.

On postback, attempts to lookup an account with a matching e-mail.  If their
account is_active and has been activated already, then they will be sent a 
password reset e-mail.

=cut

sub password_reset_request :Chained('anon_required') :PathPart('password/reset') :Args(0) {
    my ($self, $c) = @_;
    
    my $f = JakartaPM::Forms::PasswordReset->new();
    
    if ($c->req->method eq 'POST') {
        
        $f->process( params => $c->req->body_params );
        
        if ($f->validated) {
            
            my $u = $c->model('SiteDB::User')->find({ email => $f->value->{email} });
            
            if ($u) {
            
                if (!$u->is_active) {
                                        
                    $c->flash( error_msg => 'Whoops.. Looks like your account has actually been disabled by an administrator.' );    
                }
                elsif (!$u->confirmation_date) {
                                        
                    my $resend_conf_uri = $c->uri_for( $c->controller('Members')->action_for('confirm_email_resend') );
                    $c->flash( error_msg => "Hey actually you haven't confirmed your account yet. Why don't you go " . 
                        "<a href='${resend_conf_uri}'>here</a> and have your confirmation e-mail resent.");
                }
                else {
                    # ok.. their account is in good shape -- send them the reset e-mail                    
                    my $reset_key = $u->generate_reset_key();
                    my $reset_uri = $c->uri_for( $c->controller('Members')->action_for('password_reset_confirm'), [ $reset_key ] );
                    
                    $c->stash( 
                        username    => $u->username,
                        reset_uri   => $reset_uri,
                        email       => {
                            to          => $u->email,
                            from        => $c->config->{'View::Email'}->{'default'}->{from},
                            subject     => 'Jakarta.pm.org - Password Reset',
                            template    => 'password_reset.tt2',
                        },
                    );
                    $c->forward( $c->view('Email::Template') );
                    
                    $c->flash( status_msg => 'Ok!  Check your e-mail.  You should receive an e-mail from us in just a bit.' );
                    
                    my $root_uri = $c->uri_for( $c->controller('Root')->action_for('index') );
                    $c->res->redirect($root_uri);
                    $c->detach();
                }                    
            }
            else {
                $c->flash( error_msg => 'Shoot.  We actually don\'t have a record of your account.  ' . 
                    'Why don\'t you register a new one (or try a different e-mail address)?' );
            }
        } # end if $f->validated
        else {
            $c->stash( error_msg => 'Oops looks like you provided some bad form information.  Please take a second look!  Thanks a lot!' );
        }
    }
    
    $c->stash( form => $f );    
}


=head2 password_reset_confirm

=cut

sub password_reset_confirm :Chained('anon_required') :PathPart('password/reset') :Args(1) {
    my ($self, $c, $reset_key) = @_;
    
    # look for a matching reset key within the specified date range.
    my $valid_days  = $c->config->{password_reset_lifetime_days};
    my $min_dt      = DateTime->now->subtract( days => $valid_days );    
    
    $c->model('SiteDB::User')->result_source->schema->storage->debug(1);
    
    my $u = $c->model('SiteDB::User')->find({ 'reset_key' => $reset_key });
    
    my $f = JakartaPM::Forms::PasswordResetConfirm->new(); 
    
    if ($u && $u->is_active && $u->reset_date >= $min_dt) {
        
        if ($c->req->method eq 'POST') {
            
            $f->process( params => $c->req->body_params );
            
            if ($f->validated) {
            
                $u->set_password( password => $f->value->{password} );
                
                $c->flash( status_msg => 'Ok! Your password has been changed.  You can now log in.' );
                
                my $login_uri = $c->uri_for( $c->controller('Members')->action_for('login') );
                $c->res->redirect($login_uri);
                $c->detach();
                
            }
            else {
                $c->flash( error_msg => "We didn't like some of your data.  Fix it please =)" );
            }
        }        
    }
    else {
        
        $c->flash( error_msg => "I couldn't lookup the password reset you requested.  Please note, reset requests expire after 72 hours." );
        
        my $root_uri = $c->uri_for( $c->controller('Root')->action_for('index') );
        $c->res->redirect($root_uri);
        $c->detach();
    }
    
    $c->stash( form => $f );
    
}


=head1 NON-CHAINED ACTIONS

=cut

=head2 view_public_profile

=cut

sub public_profile :Path('profile') :Args(1) {
    my ($self, $c, $username) = @_;
    
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
