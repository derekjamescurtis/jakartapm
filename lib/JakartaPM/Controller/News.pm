package JakartaPM::Controller::News;
use Moose;
use namespace::autoclean;
use JakartaPM::Forms::NewsArticle;
use JakartaPM::Forms::NewsComment;
use JakartaPM::Forms::Confirm;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

JakartaPM::Controller::News - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 ACTION METHODS

=over 4

=item article_publisher_required 

Start of the processing chain for all articles that require a user to be in the news_publisher role
If the user isn't in that role

=head2 article_create

=head2 specific_article

Any actions that deal with modifications to a specific, already created article
will be chained off this method.  

If the currently-logged in user did not autor the article, or the user is not
assigned to the role of 'superuser' they will be redirected away and warned
they cannot perform the action that they're attempting.

=item article_edit

Displays a form very similar to the article create action, except this modifies an already-created
article.  

On postback, validates and then saves the Article data back to the database.  Additionally, the 
article will have a modified_date set in the database (which is null when an article is created).
After successful validation, the user will be redirected back to the article detail page.

=item article_delete

Displays a confirmation request that allows the user to confirm that, yes they really really truely
do want to delete this article (or they can click a cancel button to back off).

On postback, actually deletes this particular article and redirect the user back to the article list.

=item article_list

Displays a list of articles to the user.

TODO: actually, I don't want to populate the list of articles here.. this would be a better place to demonstrate
how to use AJAX with catalyst (I don't want to do that with the calendar because people may want to bookmark a particular
month in the calendar or copy+paste the url for a specific date somewhere..).

=item article_detail

Displays the full text of an article.

If the current user is either the Article's author, or assigned to the role of superuser,
edit and delete controls will be displays as well.

=item comment_base

This is the base action for all comment-related actions.  As part of the URL, it expects the slug 
of the Article that the comment is being left for.  The Article will be looked up and stored in
the stash for further actions.

=item comment_create

Displays a new form to the user that allows them to input the text for their comment.

TODO: Although our model supports threaded comments, we're not going to support that right
off the bat.  I don't really have the time to put into that right now, so the simpler 
things are, the better.

=item specific_comment

Base for any items in the processing chain that require action on a specifc comment that has
already been created.

=item comment_author_required

Base action for any actions that require the currently-logged in user to be the author of a 
specific comment (or to be a moderator/superuser).  

=item comment_edit

Displays a form that allows the user to edit the text of a comment.  If the user is a superuser
or a moderator, they will be able to flag the comment as 'moderator_deleted' which will still display
the author and date of a comment, but will remove the text and display 'moderator_deleted'.

On postback, changes are actually saved to the database, and the user is redirected back 
to the article.

=item comment_delete

Displays a form that prompts the user to confirm whether or not they really want to delete this comment

NOTE:  This is not the same functionality as 'moderator_deleted'.  When deleted through this mechanism, 
the comment is completely deleted from the system.

=item comment_flag

Shows a form that prompts a user whether or not they really want to flag this comment as spam.  

On postback, the comment will be flagged in the database, an email will be sent to all the 
moderators configured in the system and then the user will be redirected back to view the 
article.

=item assert_moderator

Base for any actions that require the logged in user to have moderator or superuser privileges.

If the user doesn't have the required privilege, they're bumped back to the article list page
and shown a warning message.

=item flagged_comments_list

Displays a list of all comments that have been flagged by users as spam/inappropriate.

TODO: pagination here

=back

=encoding utf8

=cut

sub auto : Private {
    my ( $self, $c ) = @_;
    
    $c->stash( 
        active_nav_id   => 'nav-news', 
        header_img_url  => '/static/images/mail.jpg',
    );
    
}

sub news_publisher_required : PathPart('news') Chained('/members/login_required') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    
    unless ( $c->check_any_user_role( qw/superuser news_publisher/ ) ){
        
        $c->flash( error_msg => 'Oh Snap Dawg! You\'re not allowed there!' );
        
        my $root_uri = $c->uri_for( $c->controller('Root')->action_for('index') );
        $c->res->redirect($root_uri);
        $c->detach();
    }    
}

sub article_create : PathPart('create') Chained('news_publisher_required') Args(0) {
    my ( $self, $c ) = @_;
    
    my $a = $c->model('SiteDB::Article')->new({ author => $c->user->get_object, });
    my $f = JakartaPM::Forms::NewsArticle->new( 
        item => $a
    );
        
    if ($c->req->method eq 'POST') {
        
        $f->process( params => $c->req->body_params );
        
        if ($f->validated) {
            
            $c->flash( status_msg => 'Article Posted!' );
            
            # TODO: raises exception 'not a code reference' at linke 165 .. not sure this if the URL lookup or the flash message being set 
            my $list_uri = $c->uri_for( $c->controller('News')->action_for('article_list') );
            $c->res->redirect($list_uri);
            $c->detach();
        }
        else {
            
            $c->flash( error_msg => 'Shoot.  There was a problem with your input' . $f->errors );
        }
    }
    
    $c->stash( form => $f );
}

sub specific_article : PathPart('') Chained('news_publisher_required') CaptureArgs(1) {
    my ( $self, $c, $slug ) = @_;
        
    # lookup the article
    my $a = $c->model('SiteDB::Article')->find({ slug => $slug });
    unless ($a) {
        
        $c->flash( error_msg => 'Unable to lookup the article you specified' );
        
        my $list_uri = $c->uri_for( $c->controller('News')->action_for('article_list') );
        $c->res->redirect($list_uri);
        $c->detach();
    }    
    
    # make sure the logged in user either owns that article, or is a superuser
    if ( $c->check_any_user_role( qw/superuser/ ) ) {
        $c->stash( article => $a );
    }
    elsif ( $c->check_any_user_role( qw/news_publisher/) && ( $c->user->id == $a->author_id )) { 
        $c->stash( article => $a );
    }
    else {
        # oh snap!
        $c->flash( error_msg => 'Only superusers or article authors can perform that action.' );
        
        my $list_uri = $c->uri_for( $c->controller('News')->action_for('article_list') );
        $c->res->redirect($list_uri);
        $c->detach();
    }
}

sub article_edit : PathPart('edit') Chained('specific_article') Args(0) {
    my ( $self, $c ) = @_;
    
    my $f = JakartaPM::Forms::NewsArticle->new( item => $c->stash->{article} );
    
    # change the article's update time to the current time
    $c->stash->{article}->modified_date(DateTime->now);
    
    # on postback, try to process the form .. if everything goes well, then show the user the form
    if ( $c->req->method eq 'POST' ) {
        
        $f->process( params => $c->req->body_params );
        
        if ($f->validated) {
            
            $c->flash( status_msg => 'Article updated!' );
            
            my $article_uri = $c->uri_for( $c->controller('News')->action_for('article_detail'), [ $c->stash->{article}->slug, ] );
            $c->res->redirect($article_uri);
            $c->detach();
        }        
    }
    
    $c->stash( form => $f );    
}

sub article_delete : PathPart('delete') Chained('specific_article') Args(0) {
    my ( $self, $c ) = @_;
    
    if ($c->req->method eq 'POST') {
        
        $c->stash->{article}->delete;
        
        $c->flash( status_msg => 'Article Deleted' );
        
        my $list_uri = $c->uri_for( $c->controller->('News')->action_for('article_list') );
        $c->res->redirect($list_uri);
        $c->detach();
    }    
}

sub article_list : Path('') Args(0) {
    my ( $self, $c ) = @_;
    
    # todo: support pagination and ajax loading of articles.. 
    
    my @articles = $c->model('SiteDB::Article')->all;
    
    $c->stash(articles => \@articles,); 
}

sub article_detail : Path('article') Args(1) {
    my ( $self, $c, $slug ) = @_;
    
    # make sure we can look up this article by it's slug
    my $a = $c->model('SiteDB::Article')->find({ slug => $slug });
    
    
    # if the user is logged in, they'll have the ability to post comments
    if ( $c->user_exists ) {
        
        my $comment = $c->model('SiteDB::Comment')->new({
            article     => $a,
            author      => $c->user->get_object,
            pub_date    => DateTime->now,     
        });
    
        my $f = JakartaPM::Forms::NewsComment->new( item => $comment );
        
        if ( $c->req->method eq 'POST' ) {
            $f->process( params => $c->req->body_params );
            if ( $f->validated ) {
                
                $c->flash( status_msg => 'Comment posted' );
                
                # force a reload of this action using a GET request now
                $c->res->redirect( $c->uri_for($c->action, [ $a->slug ]) );
                $c->detach();
            }
            else {
                $c->flash( error_msg => 'There was a problem posting your comment' );
            }
        }
        
        $c->stash( comment_form => $f );        
    }

    # rather than nastifying our template to put this crap in, we'll do it here
    my $show_edit_controls = 0;
    if ( $c->check_any_user_role( qw/superuser/ ) ) {
        $show_edit_controls = 1;
    }
    elsif ( $c->check_any_user_role( qw/news_publisher/) && ( $c->user->id == $a->author_id )) { 
        $show_edit_controls = 1;
    }
    
    # TODO: implement pagination here
    my @all_comments = $a->comments->all;
    
    
    $c->stash( 
        article             => $a, 
        show_edit_controls  => $show_edit_controls,  
        comments            => \@all_comments,
    );
    
}

sub comment_base : PathPart('comment') Chained('/members/login_required') CaptureArgs(1) {
    my ( $self, $c, $slug ) = @_;
    
    my $a = $c->model('SiteDB::Article')->find({ slug => $slug });
    
    unless ($a) {
        
        $c->flash( error_msg => 'Unable to find the article you requested' );
        
        my $list_uri = $c->uri_for( $c->controller('News')->action_for('article_list') );        
        $c->res->redirect($list_uri);
        $c->detach();
    }
    
    $c->stash( article => $a );
}

sub comment_create : PathPart('create') Chained('comment_base') Args(0) {
    my ( $self, $c ) = @_;
    
    my $comment = $c->model('SiteDB::Comment')->new({ 
        article     => $c->stash->{article},
        author      => $c->user->get_object,
        pub_date    => DateTime->now,
    });
    
    my $f = JakartaPM::Forms::NewsComment->new( item => $comment );
    
    if ( $c->req->method eq 'POST' ){
        
        $f->process( params => $c->req->body_params );
        
        if ($f->validated) {
            
            $c->flash( status_msg => 'Comment published!' );
            
            my $article_uri = $c->uri_for( $c->controller('News')->action_for('article_detail'), [ $c->stash->{article}->slug ] );
            $c->res->redirect($article_uri);
            $c->detach();
        }
    }
 
    $c->stash( form => $f );
}

sub specific_comment : PathPart('') Chained('comment_base') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    
    my $comment = $c->model('SiteDB::Comment')->find($id);
    
    # used to redirect the user back to the article if there is a problem
    my $article_uri = $c->uri_for( $c->controller('News')->action_for('article_detail'), [ $c->stash->{article}->slug ] );
    
    unless($comment){
        
        $c->flash( error_msg => 'Error looking up comment.' );
                
        $c->res->redirect($article_uri);
        $c->detach();
    }
    
    $c->stash( comment => $comment );
}

sub comment_author_required : PathPart('') Chained('specific_comment') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    
    my $is_mod      = $c->check_any_user_role(qw/superuser moderator/);
    my $is_author   = $c->user->id != $c->stash->{comment}->author_id;
    
    if ( !$is_author && !$is_mod ) {
        
        $c->flash( 'You do not have sufficient privileges to perform this action.' );
        
        my $article_uri = $c->uri_for( $c->controller('News')->action_for('article_detail'), [ $c->stash->{article}->slug ] );        
        $c->res->redirect($article_uri);
        $c->detach();
    }
    
    $c->stash(
        is_moderator    => $is_mod,
        is_author       => $is_author,
    );
}

sub comment_edit : PathPart('edit') Chained('comment_author_required') Args(0) {
    my ( $self, $c ) = @_;
    
    # create the new form -- only show 'moderator_deleted' control to mods/superusers    
    my $f = JakartaPM::Forms::NewsComment->new( 
        item    => $c->stash->{comment}, 
        active  => $c->stash->{is_moderator} ? [ 'moderator_deleted' ] : [] 
    );
    
    if ($c->req->method eq 'POST') {
        
        $f->process( params => $c->req->body_params );
        
        if ( $f->validated ) {
            
            $c->stash( status_msg => 'Comment updated!' );
            
            my $article_uri = $c->uri_for( $c->controller('News')->action_for('article_detail'), [ $c->stash->{article}->slug ] );        
            $c->res->redirect($article_uri);
            $c->detach();
        }
    }
    
    $c->stash( form => $f );    
}

sub comment_delete : PathPart('delete') Chained('comment_author_required') Args(0) {
    my ( $self, $c ) = @_;
    
    if ( $c->req->method eq 'POST' ) {
        
        $c->stash->{comment}->delete;
        
        $c->stash( status_msg => 'Comment deleted.' );
        
        my $article_uri = $c->uri_for( $c->controller('News')->action_for('article_detail'), [ $c->stash->{article}->slug ] );
        $c->res->redirect( $article_uri );
        $c->detach();
    }        
}

sub comment_flag : PathPart('flag-spam') Chained('specific_comment') Args(0) {
    my ( $self, $c ) = @_;
    
    my $f = JakartaPM::Forms::Confirm->new();
    
    if ( $c->req->method eq 'POST' ) {
        $f->process( params => $c->req->body_params );
        if ($f->validated) {
                        
            # TODO: send an e-mail out to moderators
            
            # update the database
            $c->stash->{comment}->requires_moderation(1);
            $c->stash->{comment}->update;
            
            $c->flash( status_msg => 'A moderator has been notified and will take a look at this asap.' );
            
            my $article_uri = $c->uri_for( $c->controller('News')->action_for('article_detail'), [ $c->stash->{article}->slug, ] );
            $c->res->redirect($article_uri);
            $c->detach();
        }
    }    
    
    $c->stash( form => $f );
}

sub assert_moderator : PathPart('moderator') Chained('/members/login_required') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    
    unless ( $c->check_any_user_role(qw/moderator superuser/) ) {
        
        $c->flash( error_msg => 'You must granted the "moderator" privilege to access this page.' );
        
        my $list_uri = $c->uri_for( $c->controller('News')->action_for('article_list') );
        $c->res->redirect($list_uri);
        $c->detach();
    }
}

sub flagged_comments_list : PathPart('flagged-comments') Chained('assert_moderator') Args(0) {
    my ( $self, $c ) = @_;
    
    my @flagged = $c->model('SiteDB::Comment')->search({ requires_moderation => 1 })->all;
    $c->stash( flagged => \@flagged )    
}

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
