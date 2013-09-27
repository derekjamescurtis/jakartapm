package JakartaPM::Forms::Login;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

has '+is_html5' => ( default => 1);
has '+widget_wrapper' => ( default => 'Bootstrap3' );

has_field 'username' => ( type => 'Text', required => 1 );
has_field 'password' => ( type => 'Password', required => 1 );
has_field 'submit' => ( type => 'Submit', element_class => 'btn btn-primary', value => 'Login' );

1;