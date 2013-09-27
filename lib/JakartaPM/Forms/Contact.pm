package JakartaPM::Forms::Contact;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

has '+is_html5' => ( default => 1 );
has '+widget_wrapper' => ( default => 'Bootstrap3' );

has_field 'name' => ( type => 'Text', required => 1, minlength => 5, maxlength => 50);
has_field 'email' => ( type => 'Email', required => 1 );
has_field 'message' => ( type => 'TextArea', required => 1, minlength => 5 ); 
has_field 'submit' => ( type => 'Submit', value => 'Send Message', element_class => 'btn btn-primary', );

1;