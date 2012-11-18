package MancalaWeb::Model::Games;
use Mancala::Game;
use Data::Structure::Util qw{unbless};
use Data::UUID;
use Data::Dumper;
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

=head1 AUTHOR

Greg Hellings,,,

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

sub create {
    my ($self,$player1, $player2) = @_;
    my $game = Mancala::Game->new( player1 => $player1, player2 => $player2);
    my $game_copy = $game->clone;
    my $gamedata = unbless $game_copy;
    my $oid = $self->collection->insert($gamedata);
    my $ug = Data::UUID->new;
    my $gameid = $ug->create_from_name_str("Game",$oid);
    $self->collection->update({ _id => $oid }, { gameid => $gameid } );
    $game->gameid($gameid);
    $game->board;
    print Dumper $game;
    $gamedata = unbless $game;
    return $gamedata;
}

sub fetch_game_obj {
    my ( $self, $gameid ) = @_;
    my $gamedata = $self->collection->find_one( { gameid => $gameid } );
    my $game = Mancala::Game->new( $gamedata );
    return $game;
}

sub save_game_obj {
    my ( $self, $game ) = @_;
    my $gameid = $game->gameid;
    unbless $game;
    my $oid = $self->collection->update( { gameid => $gameid }, $game );
    return $oid;
}

sub fetch_game_json {
    my ( $self, $gameid ) = @_;
    my $gamedata = $self->collection->find_one( { gameid => $gameid } );
    delete $gamedata->{'_id'};
    return $gamedata;
}


no Moose;
__PACKAGE__->meta->make_immutable;

1;
