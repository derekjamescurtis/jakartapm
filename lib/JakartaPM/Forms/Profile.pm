package JakartaPM::Forms::Profile;
use Locale::SubCountry;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

has '+is_html5' => ( default => 1 );

has_field 'email' => ( type => 'Email', required => 1 );
has_field 'about_me' => ( type => 'TextArea',  );

has_field 'city' => ( type => 'Text' );
has_field 'province' => ( type => 'Text' );
has_field 'country' => ( type => 'Select' );
has_field 'submit' => ( type => 'Submit', value => 'submit' );


=head2 _get_country_choices 

We need to get an array ref of hash refs [{ label=>?, value=>? }]
to hand back to our country field choices.  

=cut
sub options_country {
    my $self = shift;
   
    my $w = Locale::SubCountry::World->new;
    my %code_country = $w->code_full_name_hash;     
     
    return map {{ value => $_, label => $code_country{$_} . " ($_)" }} sort keys %code_country;          
}


1;
