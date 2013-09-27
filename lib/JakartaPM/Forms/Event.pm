package JakartaPM::Forms::Event;
use HTML::FormHandler::Moose;
use DateTime;
extends 'HTML::FormHandler::Model::DBIC';

has '+is_html5' => ( default => 1 );
has '+widget_wrapper' => ( default => 'Bootstrap3' );

has_field 'summary' => ( type => 'Text', required => 1 );
has_field 'description' => ( type => 'TextArea', required => 1 );
has_field 'organizer' => ( type => 'Select', label_column => 'username', active_column => 'id', required => 1 );

has_field 'dtstart' => ( type => 'DateTime', required => 1, default => DateTime->now->add( hours => 7 ), );
has_field 'dtstart.month' => ( type => 'Month' );
has_field 'dtstart.day' => ( type => 'MonthDay' );
has_field 'dtstart.year' => ( type => 'Year' );
has_field 'dtstart.hour' => ( type => 'Hour' );
has_field 'dtstart.minute' => ( type => 'Minute' );

has_field 'dtend' => ( type => 'DateTime', required => 1, default => DateTime->now->add( hours => 7 ) );
has_field 'dtend.month' => ( type => 'Month' );
has_field 'dtend.day' => ( type => 'MonthDay' );
has_field 'dtend.year' => ( type => 'Year' );
has_field 'dtend.hour' => ( type => 'Hour' );
has_field 'dtend.minute' => ( type => 'Minute' );

has_field 'submit' => ( type => 'Submit', value => 'Save' );


sub validate {
    my $self = shift;
    
    # make sure dtstart is before dtend
    my $start_time  = $self->field('dtstart')->value;
    my $end_time    = $self->field('dtend')->value;    
    if (DateTime->compare($start_time, $end_time) > 0) {
        $self->field('dtstart')->add_error('Start Time must be prior to End Time');        
    }
    
    # make sure they're on the same day .. just to make logical sense
    $start_time->truncate( to => 'day' );
    $end_time->truncate( to => 'day' );
    if (DateTime->compare($start_time, $end_time) != 0) {
        $self->field('dtstart')->add_error('Start Time and End Time must be on the same calendar date.');
    }
    
}

1;