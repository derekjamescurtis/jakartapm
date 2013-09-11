package JakartaPM::Forms::Confirm;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

has '+is_html5' => ( default => 1 );

has_field 'submit' => ( type => 'Submit', value => "Yes, I'm sure." );

1;