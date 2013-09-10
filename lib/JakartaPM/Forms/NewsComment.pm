package JakartaPM::Forms::NewsComment;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

has '+is_html5' => ( default => 1 );

has_field 'content' => ( type => 'TextArea', required => 1 );
has_field 'moderator_deleted' => ( type => 'Checkbox', inactive => 1 );
has_field 'submit' => ( type => 'Submit', value => 'Post' );

1;