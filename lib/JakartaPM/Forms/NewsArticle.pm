package JakartaPM::Forms::NewsArticle;
use HTML::FormHandler::Moose;
use DateTime;
extends 'HTML::FormHandler::Model::DBIC';

has '+is_html5' => ( default => 1 );

has_field 'title' => ( type => 'Text', required => 1 );
has_field 'slug' => ( type => 'Text', required => 1 );
has_field 'lang' => ( type => 'Select', options => [{ label => 'id', value => 'id' },{ label => 'en', value => 'en' },], required => 1 );
has_field 'content' => ( type => 'TextArea', required => 1 );

has_field 'pub_date' => ( type => 'DateTime', required => 1, default => DateTime->now->add( hours => 7 ) );
has_field 'pub_date.month' => ( type => 'Month' );
has_field 'pub_date.day' => ( type => 'MonthDay' );
has_field 'pub_date.year' => ( type => 'Year' );
has_field 'pub_date.hour' => ( type => 'Hour' );
has_field 'pub_date.minute' => ( type => 'Minute' );

has_field 'is_locked' => ( type => 'Checkbox' );

has_field 'submit' => ( type => 'Submit', value => 'Save' );

1;