package MancalaWeb::Controller::Game;
use Moose;
use Data::UUID;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

MancalaWeb::Controller::Game - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched MancalaWeb::Controller::Game in Game.');
}


=head2 create

=cut

sub create :Local {
     my ( $self, $c ) = @_;
     my $player1 = $c->model('Players')->fetch_player_obj( $c->req->body_params->{'player1'} );
     my $player2 = $c->model('Players')->fetch_player_obj( $c->req->body_params->{'player2'} );
     my $gamedata = $c->model('Games')->create( $player1, $player2 );
     $c->stash( game => $gamedata );
}


=head2 fetch

=cut

sub fetch :Local {
    my ( $self, $c ) = @_;
    my $gamedata = $c->model('Games')->fetch_game_json( $c->req->body_params->{'gameid'} );
    $c->stash( game => $gamedata );
}


=head2 move

=cut

sub checkmove :Local {
    my ( $self, $c ) = @_;
    my $gameid = $c->req->body_params->{'gameid'};
    my $house = $c->req->body_params->{'house'};
    my $player = $c->req->body_params->{'playerid'};
    my $game = $self->model('Games')->fetch_game_obj($gameid);
    my $ug = Data::UUID->new;
    my $res = $ug0=->compare($player,
    my $valid_input = $game->board->move($input  


=head1 AUTHOR

Greg Hellings

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
