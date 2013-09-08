package JakartaPM::Forms::PasswordReset;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

has '+is_html5' => ( default => 1 );

has_field 'email' => ( type => 'Email', required => 1 );
has_field 'submit' => ( type => 'Submit', value => 'Submit' );

1;