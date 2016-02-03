// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class AnimNotify_SetSpeed extends AnimNotify_Scripted;

var() float Rate;

event Notify( Actor Owner )
{
   AdvancedPawn(Owner).Notify_SetSpeed(Rate);
}

defaultproperties
{
     Rate=1.000000
}
