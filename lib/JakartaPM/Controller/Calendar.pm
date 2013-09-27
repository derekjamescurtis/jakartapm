package JakartaPM::Controller::Calendar;
use Moose;
use namespace::autoclean;
use JakartaPM::Forms::Event;
use DateTime;

BEGIN { extends 'Catalyst::Controller'; }

__PACKAGE__->config(namespace => 'events');

=head1 NAME

JakartaPM::Controller::Calendar - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

I should actually probably changed the name of this controller from Calendar to Events.. 

=head1 ACTION METHODS

=over 4

=item assert_event_publisher

Requires that the current logged-in user has the role of 'event_publisher' or 'superuser'

=item event_create

=item events

By default, we'll let people access our events calendar without specifying a year/month in the URL. 
If they don't, then we'll assume they want to see the current year/month.

=item events_for_year_month

Same as the events sub, 

URL: /events/{year}/{month}

=back

=encoding utf8

=cut

sub assert_event_publisher : PathPart('events') Chained('/members/login_required') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    
    unless ($c->check_any_user_role(qw/superuser event_publisher/)) {
        
        $c->flash( error_msg => "Sorry, you don't have permission to go there." );
        
        my $root_uri = $c->uri_for( $c->controller('Root')->action_for('index') );
        $c->res->redirect( $root_uri );
        $c->detach();
    }
}

sub event_create : PathPart('create') Chained('assert_event_publisher') Args(0) {
    my ( $self, $c ) = @_;
    
    my $e = $c->model('SiteDB::Event')->new({ 
        dtstart => DateTime->now,
        dtend   => DateTime->now->add( hours => 1 ),
        dtstamp => DateTime->now,
    });
    my $f = JakartaPM::Forms::Event->new( item => $e );
    
    # if the method is post, then try to validate and write to the database
    if ($c->req->method eq 'POST') {
       
        # on a post request, we need to also manually generate and assign a UID to our event object
        # (it's part of iCal, that we want to support)
        $e->uid( sprintf( '%s-%s@jakarta.pm.org', $e->dtstart, $e->dtend ));
        
        $f->process( params => $c->req->body_params );
        if ( $f->validated ) {
            
            $c->flash( status_msg =>  'Event Created!' );
            
            # redirect the client to view the event they just made
            my $a = $c->controller('Calendar')->action_for('event_detail');
            my $event_uri = $c->uri_for( $a, [ $e->id ] );
            $c->res->redirect( $event_uri );
            $c->detach();            
        }
    }    
     
    $c->stash(
        form => $f,
        template => 'calendar/event_create.tt2',
    );    
}

sub specific_event : PathPart('event') Chained('/') CaptureArgs(1) {
    my ( $self, $c, $event_id ) = @_;
    
    my $event = $c->model('SiteDB::Event')->find($event_id);
    
    if (!defined $event) {
        $c->flash( error_msg => 'Oops. We couldn\'t find the event you were looking for.' );
        
        my $events_uri = $c->uri_for( $c->controller('Calendar')->action_for('events') );
        $c->res->redirect( $events_uri );
        $c->detach;        
    }
    
    $c->stash( event => $event );
}

sub alter_event : PathPart('') Chained('specific_event') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    
    my $a = $c->controller('Calendar')->action_for('assert_event_publisher');
    $c->forward( $a );    
}

sub event_edit : PathPart('edit') Chained('alter_event') Args(0) { 
    my ( $self, $c ) = @_;
    
    my $e = $c->stash->{event};
    my $f = JakartaPM::Forms::Event->new( item => $e );
    
    if ( $c->req->method eq 'POST' ) {
        
        $f->process( params => $c->req->body_params );
        
        if ( $f->validated ) {
            
            $c->flash( status_msg => 'Updated event!' );
            
            my $event_uri = $c->uri_for( $c->controller('Calendar')->action_for('event_detail'), [ $e->id, ] );
            $c->res->redirect( $event_uri );
            $c->detach();
        }
    }
    
    $c->stash( 
        form => $f,
        template => 'calendar/event_edit.tt2', 
    );    
}

sub event_delete : PathPart('delete') Chained('alter_event') Args(0) { 
    my ( $self, $c ) = @_;
    
    my $e = $c->stash->{event};
    
    if ( $c->req->method eq 'POST' ) {
        
        $e->delete;
        
        $c->flash( status_msg => 'Event deleted.' );
        
        my $events_uri = $c->uri_for( $c->controller('Calendar')->action_for('events') );
        $c->res->redirect( $events_uri );
        $c->detach();
    }
    
    $c->stash( template => 'calendar/event_delete.tt2' );
    
}

sub event_detail : PathPart('') Chained('specific_event') Args(0) { 
    my ($self, $c) = @_;
    
    # display edit controls if the user is allowed to edit this article
    if ($c->check_any_user_role(qw/superuser event_publisher/)) {
        $c->stash( show_edit_controls => 1 );
    }
    
    $c->stash( template => 'calendar/event_detail.tt2' );    
}

sub events : Path('') Args(0) {
    my ( $self, $c ) = @_;
    
    my $dt = DateTime->now();
    my $action = $c->controller('Calendar')->action_for('events_for_year_month');
    
    # in this case, we actually turn the processing over to the events_for_year_months action so we keep our code dry
    $c->detach($action, [ $dt->year(), $dt->month() ]);
}

sub events_for_year_month : Path('') Args(2) {
    my ( $self, $c, $year, $month ) = @_;
    
    my $dt      = DateTime->new(month => $month, year => $year);
    
    # used to display links to previous/next months' events
    my $prev    = $dt->clone->subtract(months => 1);
    my $next    = $dt->clone->add(months => 1);
    
    # only used here in the following query so we know when this month ends 
    my $end_of_month = DateTime->last_day_of_month(month => $month, year => $year, hour => '23', minute => '59', second => '59');
    
    my @events = $c->model('SiteDB::Event')->search({ 
            dtstart => { '>=' , $dt }, 
            dtend   => { '<=' , $end_of_month } }
        )->all();
     
    $c->stash(        
        events      => \@events,
        is_historic => DateTime->compare( $dt, DateTime->now->truncate( to => 'month' )) < 0 ? 1 : 0,
        date        => $dt,
        prev_date   => $prev,
        next_date   => $next,
        template    => 'calendar/events.tt2',
    );    
}


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
