package JakartaPM::Forms::LoginRegister;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('NotAllDigits');
extends 'HTML::FormHandler';

=head1 NAME 

JakartaPM::Forms::LoginRegister

=head2 DESCRIPTION

A form that is displayed for the /login page. This form actually allows the user either to log in 
to the application, or register for a new user account.

Because of this, the password_confirm and email fields must manually be disabled for processing.

The password field has very few built-in validators right out of the box.
However, for our relatively simple site, we're only going to set 2 requirements right 
out of the box (6 chars, not all digits).  We could easily set a custom validation 
method though, if we really needed to (in most other production sites.. yeah.. you're 
probably going to want to do that =P)

=cut

has_field 'username' => ( 
    type => 'Text', 
    label => 'Username',
    required => 1, 
    minlength => 3,
    element_class => 'form-control', 
    wrapper_class => 'form-group');
has_field 'password' => ( 
    type => 'Password', 
    label => 'Password',
    required => 1, 
    minlength => 6, # this is actually the default, but I'm defining explicitally as an example
    apply => [ NotAllDigits, ],
    element_class => 'form-control', 
    wrapper_class => 'form-group' );
has_field 'new_or_existing' => ( 
    type => 'Checkbox', 
    label => 'Register new Account', 
    label_attr => { style => 'display:inline-block' }, 
    checkbox_value => 'new', 
    wrapper_class => 'form-group' );
has_field 'password_confirm' => ( 
    type => 'PasswordConf', 
    label => 'Confirm Password', 
    required => 1,
    element_class => 'form-control', 
    wrapper_class => 'form-group' );
has_field 'email' => ( 
    type => 'Email', 
    label => 'E-mail Address',
    required => 1, 
    element_class => 'form-control', 
    wrapper_class => 'form-group' );
has_field 'submit' => ( 
    type => 'Submit', 
    value => 'Login', 
    element_class => 'btn btn-primary', 
    wrapper_class => 'form-group');

1;