package MancalaWeb::Controller::Player;
use Moose;
use Data::Dumper;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

MancalaWeb::Controller::Player - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched MancalaWeb::Controller::Player in Player.');
}

=cut

=head2 create

=cut

sub create :Local {
    my ( $self, $c ) = @_;
    my $playerdata = $c->model('Players')->create($c->req->body_params->{'name'},int($c->req->body_params->{'position'}));
    $c->stash( player => $playerdata );
}

=cut

=head2 fetch

=cut

sub fetch :Local {
    my ( $self, $c ) = @_;
    my $playerdata = $c->model('Players')->fetch_player_json( $c->req->body_params->{'playerid'} );
    $c->stash( player => $playerdata );
}

=head1 AUTHOR

Greg Hellings,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
