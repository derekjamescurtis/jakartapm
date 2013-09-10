package JakartaPM::Controller::Root;
use Moose;
use namespace::autoclean;
use JakartaPM::Forms::Contact;
use DateTime;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

JakartaPM::Controller::Root - Root Controller for JakartaPM

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    
    
}

=head2 about

=cut
sub about :Path('about') :Args(0) {
    my ( $self, $c ) = @_;
}

=head2 events

By default, we'll let people access our events calendar without specifying a year/month in the URL. 
If they don't, then we'll assume they want to see the current year/month.

=cut
sub events :Path('events') :Args(0) {
    my ( $self, $c ) = @_;
    
    my $dt = DateTime->now();
    my $action = $c->controller->action_for('events_for_year_month');
    
    # in this case, we actually turn the processing over to the events_for_year_months action so we keep our code dry
    $c->detach($action, [ $dt->year(), $dt->month() ]);
}

=head2 events_for_year_month

    URL: /events/{year}/{month}
=cut

sub events_for_year_month :Path('events') :Args(2) {
    my ( $self, $c, $year, $month ) = @_;
    
    my $dt      = DateTime->new(month => $month, year => $year);
    my $prev    = $dt->clone->subtract(months => 1);
    my $next    = $dt->clone->add(months => 1);
    
    # todo: get and stash our calendar events
    
    $c->stash(
        date        => $dt,
        prev_date   => $prev,
        next_date   => $next,
        template    => 'events.tt2',
    );
    
}

=head2 contact

Dispalys a form that allows any user to send an e-mail to us without
exposing our e-mail address publically.  The actual email address that receives
this message can be found in this app's .conf file.

On postback the data they've entered is validated, and if everything goes well
is e-mailed to us!

=cut

sub contact :Path('contact') :Args(0) {
    my ( $self, $c ) = @_;
    
    my $f = JakartaPM::Forms::Contact->new();
    
    if ($c->req->method eq 'POST') {
        
        $f->process( params => $c->req->body_params );
        
        if ($f->validated()) {
            
            $c->stash(
                sender_name     => $f->value->{name},
                sender_email    => $f->value->{email},
                sender_message  => $f->value->{message},
                email           => {
                    to              => $c->config->{contact_page_recipiant},
                    from            => $c->config->{'View::Email'}->{'default'}->{from},
                    subject         => 'Jakarta.pm.org - Contact Us Message',
                    template        => 'contact_us_message.tt2',
                }
            );
            $c->forward( $c->view('Email::Template') );
                        
            $c->flash(status_msg => "Alright!  Your message has been sent.  We'll get back to you just as quickly as we can!");
            
            my $root_uri = $c->uri_for($c->controller->action_for('index'));            
            $c->res->redirect($root_uri);
            $c->detach();
        }
        else {
            $c->flash(error_msg => 
                "Hey.. there was a problem with some of the data you provided.. probably a typeo!  " . 
                "Don't you hate those??  I know I do!  Anyway, check the data you've entered and try again!"
            );            
        }
    }
        
    $c->stash(form => $f);    
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

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
