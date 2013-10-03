package JakartaPM::Forms::Register;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('NotAllDigits');
extends 'HTML::FormHandler';

=head1 NAME 

JakartaPM::Forms::Register

=head2 DESCRIPTION

A form that is displayed for the /register page. This form actually allows the user or register for a new user account.

This form has one special attribute, a reference to the application's catalyst object must be passed into the constructor
as a named parameter (called catalyst).  This is used to perform database validation to make sure our username and e-mail 
address fields are unique.

=cut

has '+is_html5' => ( default => 1 );
has '+widget_wrapper' => ( default => 'Bootstrap3' );

# this is used by our validation methods.  I am not using a database form because I don't want to automatically write this
# data to the database.. I want to handle that manually, in either the models or controllers.
has 'catalyst' => ( is => 'ro', required => 1 );

has_field 'username' => ( type => 'Text', label => 'Username', required => 1, minlength => 3, maxlength => 50 );
has_field 'password' => (  type => 'Password', label => 'Password', required => 1, minlength => 6,  apply => [ NotAllDigits, ], ); # min length defaults to 6.. but just wanted to be verbose
has_field 'password_confirm' => ( type => 'PasswordConf', label => 'Confirm Password', required => 1, );
has_field 'email' => ( type => 'Email', label => 'E-mail Address', required => 1, );
has_field 'submit' => ( type => 'Submit', element_class => 'btn btn-primary', value => 'Register', );




sub validate_username {
    my ( $self, $field ) = @_;
    
    my $match_ct = $self->catalyst->model('SiteDB::User')->search({ 'LOWER(me.username)' => lc $field->value })->count;
    
    if ($match_ct){
        $field->add_error( 'Hey!  Someone\'s alreaedy using that username =/  Sorry.' );
    }
    
}


sub validate_email {
    my ( $self, $field ) = @_;
    
    my $match_ct = $self->catalyst->model('SiteDB::User')->search({ 'LOWER(me.email)' => lc $field->value })->count;
    
    if ($match_ct) {
        $field->add_error( 'Hey!  Someone\'s already registered that e-mail address!' );
    }
    
}

1;