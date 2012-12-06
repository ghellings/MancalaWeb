package MancalaWeb::Model::Games;
use Data::UUID;
use Data::Dumper;
use Mancala::Game;
use Moose;
BEGIN { extends 'Catalyst::Model::MongoDB' };

__PACKAGE__->config(
	host => 'localhost',
	port => '27017',
	dbname => 'mancala',
	collectionname => 'games',
	gridfs => '',
);

=head1 NAME

MancalaWeb::Model::Games - MongoDB Catalyst model component

=head1 SYNOPSIS

See L<MancalaWeb>.

=head1 DESCRIPTION

MongoDB Catalyst model component.

=head1 Methods

=cut

=head2 create

Creates a new game object and returns packed hash of it

=cut

sub create {
    my ($self,$player1, $player2) = @_;
    # Create new game object
    print Dumper \$player1, \$player2;
    my $game = Mancala::Game->new( player1 => $player1, player2 => $player2 );
    # build board
    $game->board;
    # clone game
    my $copy_of_game = $game->clone;
    # pack game into hash
    $copy_of_game->pack;
    # save game in mongo
    my $oid = $self->collection->insert($copy_of_game);
    # get oid from mongo to use to create new UUID for gameid
    my $ug = Data::UUID->new;
    my $gameid = $ug->create_from_name_str("Game",$oid);
    # update saved game with gameid
    $self->collection->update({ _id => $oid }, { '$set' => {gameid => $gameid }});
    # update game object with gameid
    $game->gameid($gameid);
    # pack game into hash for return
    $game->pack;
    return $game;
}

=head2 fetch_game_obj

Get game object from mongo and return object

=cut

sub fetch_game_obj {
    my ( $self, $gameid ) = @_;
    my $gamedata = $self->collection->find_one( { gameid => $gameid } );
    print Dumper \$gamedata;
    my $game = Mancala::Game->unpack( $gamedata );
    return $game;
}


=head2 fetch_game_json

Get game object from mongo and return packed hash

=cut

sub fetch_game_json {
    my ( $self, $gameid ) = @_;
    my $gamedata = $self->collection->find_one( { gameid => $gameid } );
    delete $gamedata->{'_id'};
    return $gamedata;
}


=head2 save_game_obj

Save game object in mongo

=cut

sub save_game_obj {
    my ( $self, $game ) = @_;
    my $gameid = $game->gameid;
    $game->pack;
    my $oid = $self->collection->update( { gameid => $gameid }, $game );
    return $oid;
}



=head1 AUTHOR

Greg Hellings,,,

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

no Moose;
__PACKAGE__->meta->make_immutable;

1;
