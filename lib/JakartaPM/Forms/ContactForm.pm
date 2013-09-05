package JakartaPM::Forms::ContactForm;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

has_field 'name' => ( type => 'Text', required => 1, minlength => 5, maxlength => 50);
has_field 'email' => ( type => 'Email', required => 1 );
has_field 'message' => ( type => 'TextArea', required => 1, minlength => 5 ); 
has_field 'submit' => ( type => 'Submit', value => 'Send Message' );

1;