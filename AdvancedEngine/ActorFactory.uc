// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ActorFactory extends AdvancedActor
placeable;

var() class<Actor> theActor;
var() EPhysics initialPhysics;
var(Events) editconst Name hSpawn;

function TriggerEx(Actor Other, Pawn EventInstigator, Name Handler){
   local actor temp;
   temp = Spawn(theActor);
   temp.SetPhysics(initialPhysics);
}

defaultproperties
{
     InitialPhysics=PHYS_Falling
     hSpawn="SPAWN_ACTOR"
     bHasHandlers=True
}
