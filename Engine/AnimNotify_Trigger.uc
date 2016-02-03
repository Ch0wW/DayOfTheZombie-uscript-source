// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class AnimNotify_Trigger extends AnimNotify_Scripted;

var() name EventName;

event Notify( Actor Owner )
{
	Owner.TriggerEvent( EventName, Owner, Pawn(Owner) );
}

defaultproperties
{
}
