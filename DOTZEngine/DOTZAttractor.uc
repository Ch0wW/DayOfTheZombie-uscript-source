// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class DOTZAttractor extends Attractor
placeable;

var Sound EnabledSound;

function Activate( Pawn instigator ){
   Super.Activate( instigator );
   AmbientSound = EnabledSound;
}

function Deactivate(){
   Super.Deactivate();
   AmbientSound = None;
}

defaultproperties
{
}
