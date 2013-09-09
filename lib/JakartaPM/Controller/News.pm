package JakartaPM::Controller::News;
use Moose;
use namespace::autoclean;
use JakartaPM::Forms::NewsArticle;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

JakartaPM::Controller::News - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut



=head2 article_publisher_required 

Start of the processing chain for all articles that require a user to be in the news_publisher role
If the user isn't in that role

=cut

sub news_publisher_required :PathPart('news') :Chained('/members/login_required') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    
    unless ( $c->check_any_user_role( qw/superuser news_publisher/ ) ){
        
        $c->flash( error_msg => 'Oh Snap Dawg! You\'re not allowed there!' );
        
        my $root_uri = $c->uri_for( $c->controller('Root')->action_for('index') );
        $c->res->redirect($root_uri);
        $c->detach();
    }    
}

=head2 article_create

=cut

sub article_create :PathPart('create') :Chained('news_publisher_required') :Args(0) {
    my ( $self, $c ) = @_;
    
    my $f = JakartaPM::Forms::NewsArticle->new( 
        item => $c->model('SiteDB::Article')->new({ 
            author      => $c->user->get_object,            
        }));
    
    
    if ($c->req->method eq 'POST') {
        
        $f->process( params => $c->req->body_params );
        
        if ($f->validated) {
            
            $c->flash( status_msg => 'Article Posted!' );
            
            my $list_uri = $c->uri_for( $c->controller->('News')->action_for('article_list') );
            $c->res->redirect($list_uri);
            $c->detach();
        }
        else {
            
            $c->flash( error_msg => 'Shoot.  There was a problem with your input' . $f->errors );
        }
    }
    
    $c->stash( form => $f );
}
sub article_edit {
    
}
sub article_delete {
    
}


# article/create
# article/{slug}   -- view
# article/{slug}/edit
# article/{slug}/delete

sub article_list :Path('') :Args(0) {
    my ( $self, $c ) = @_;
    
    my @articles = $c->model('SiteDB::Article')->all;
    
    $c->stash(articles => \@articles,); 
}
sub article_detail :Path('article') :Args(1) {
    my ( $self, $c, $slug ) = @_;
    
    # make sure we can look up this article by it's slug
    my $a = $c->model('SiteDB::Article')->find({ slug => $slug });
    
    $c->stash( article => $a );
    
}



=encoding utf8

=head1 AUTHOR

Derek J. Curtis <djcurtis@summersetsoftware.com>
Summerset Software, LLC
http://www.summersetsoftware.com

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
