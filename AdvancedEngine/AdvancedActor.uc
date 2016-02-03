// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class AdvancedActor extends Actor;

var byte iRepIndex; //generic index to clients to use to set up state

replication{
    // Things the server should send to the client.
    reliable if( bNetDirty && Role==ROLE_Authority )
        iRepIndex;
}

defaultproperties
{
}
