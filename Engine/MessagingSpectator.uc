// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// MessagingSpectator - spectator base class for game helper spectators which receive messages
//=============================================================================

class MessagingSpectator extends PlayerController
	abstract;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	bIsPlayer = False;
}

defaultproperties
{
}
