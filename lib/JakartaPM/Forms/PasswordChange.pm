package JakartaPM::Forms::PasswordChange;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types qw/ NotAllDigits /;
extends 'HTML::FormHandler';

has '+is_html5' => ( default => 1 );


has_field 'password_current' => ( type => 'Password', required => 1, );
has_field 'password' => ( type => 'Password', required => 1, apply => [ NotAllDigits ], );
has_field 'password_confirm' => ( type => 'PasswordConf', required => 1, );
has_field 'submit' => ( type => 'Submit', value => 'Change Password', );


1;