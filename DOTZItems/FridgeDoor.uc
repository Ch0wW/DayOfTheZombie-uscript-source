// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class FridgeDoor extends ActionableSkeletalMesh;

defaultproperties
{
     ActionMessage="Press Action to search fridge"
     ActionSeq(0)=(AnimationName="FreezerDoorOpen",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectFridgeOpen')
     ActionSeq(1)=(AnimationName="FreezerDoorClose",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectFridgeOpen')
     ActionSeq(2)=(AnimationName="FridgeDoorOpen",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectFridgeOpen')
     ActionSeq(3)=(AnimationName="FridgeDoorClose",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectFridgeOpen')
     Mesh=SkeletalMesh'DOTZASearchable.FridgeDoor'
}
