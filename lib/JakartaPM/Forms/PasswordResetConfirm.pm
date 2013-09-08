package JakartaPM::Forms::PasswordResetConfirm;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types qw/ NotAllDigits /;
extends 'HTML::FormHandler';

has '+is_html5' => ( default => 1 );

has_field 'password' => ( type => 'Password', required => 1, minlength => 6, apply => [ NotAllDigits, ] );
has_field 'password_confirm' => ( type => 'PasswordConf', required => 1 );
has_field 'submit' => ( type => 'Submit', value => 'Submit' );

1;