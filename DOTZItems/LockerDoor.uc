// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class LockerDoor extends ActionableSkeletalMesh;

defaultproperties
{
     ActionMessage="Press Action to search locker"
     ActionSeq(0)=(AnimationName="DoorOpen",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectCabinetMetalOpen')
     ActionSeq(1)=(AnimationName="DoorClose",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectCabinetMetalClose')
     Mesh=SkeletalMesh'DOTZASearchable.LockerDoor'
}
