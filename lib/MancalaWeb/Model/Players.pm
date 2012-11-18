package MancalaWeb::Model::Players;
use Mancala::Player;
use Data::Structure::Util qw{unbless};
use Data::UUID;
use Data::Dumper;
use Moose;
BEGIN { extends 'Catalyst::Model::MongoDB' };

__PACKAGE__->config(
	host => 'localhost',
	port => '27017',
	dbname => 'mancala',
	collectionname => 'players',
	gridfs => '',
);

=head1 NAME

MancalaWeb::Model::Players - MongoDB Catalyst model component

=head1 SYNOPSIS

See L<MancalaWeb>.

=head1 DESCRIPTION

MongoDB Catalyst model component.

=cut

=head2 create

=cut

sub create {
    my ($self, $name, $position) = @_;
    my $player;
    my $playerdata = $self->collection->find_one( { name => $name } );
    unless ( $playerdata ) {
        my $ug = Data::UUID->new;
        my $uuid = $ug->create_from_name_str("Player",$name);
        $player = Mancala::Player->new( name => $name, position => $position, playerid => $uuid );
        $playerdata = unbless $player;
        $self->collection->insert($playerdata);
    }
    else{
        bless( $playerdata, 'Mancala::Player');
        $player = $playerdata;
        $player->position($position);
    }
    $playerdata = unbless $player;
    return $player;
}

sub fetch_player_obj {
    my ($self, $playerid) = @_;
    my $playerdata = $self->collection->find_one( { playerid => $playerid } );
    my $player = Mancala::Player->new( $playerdata);
    return $player;
}

sub fetch_player_json {
    my ($self, $playerid) = @_;
    my $playerdata = $self->collection->find_one( { playerid => $playerid } );
    delete $playerdata->{'_id'};
    return $playerdata;
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
