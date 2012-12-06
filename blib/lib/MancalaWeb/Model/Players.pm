package MancalaWeb::Model::Players;
use Mancala::Player;
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
    my ($self, $c ) = @_;
    my $player;
    # Look for the player in mongo
    my $playerdata = $self->collection->find_one( { name => $c->{'name'} } );
        print "Player Data Object \n";
    # Create a new player if one doesn't exist
    unless ( $playerdata ) {
        # Create playerid
        my $ug = Data::UUID->new;
        my $uuid = $ug->create_from_name_str("Player",$c->{'name'});
        # Create new player object
        $player = Mancala::Player->new( name => $c->{'name'}, position => $c->{'position'}, playerid => $uuid );
        # Clone object for packing
        my $copy_of_player = $player->clone;
        # Turn object into hashref
        $copy_of_player->pack;
        # Store in mongo
        $self->collection->insert($copy_of_player);
    }
    else{
        # Unpack player data into player object
        $playerdata->{'position'} = $c->{'position'};
        $player = Mancala::Player->unpack( $playerdata );
        # Set position
    }
    # Turn player into hash
    my $return_data = $player->pack;
    print Dumper \$return_data; 
    return $return_data;
}

=head2 fetch_player_obj

=cut

sub fetch_player_obj {
    my ($self, $playerid ) = @_;
    # Find player in mongo
    my $playerdata = $self->collection->find_one( { playerid => $playerid } );
    print "Mongo Lookup\n";
    print Dumper \$playerdata;
    # Unpack object
    my $player = Mancala::Player->unpack( $playerdata );
    return $player;
}

=head2 fetch_player_hash

=cut

sub fetch_player_hash {
    my ($self, $playerid ) = @_;
    # Find player in Mongo
    my $playerdata = $self->collection->find_one( { playerid => $playerid } );
    # Remove _id 
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
