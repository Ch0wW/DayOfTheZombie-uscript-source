// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class MedicineCabinetDoor extends ActionableSkeletalMesh;

defaultproperties
{
     ActionMessage="Press Action to search medicine cabinet"
     ActionSeq(0)=(AnimationName="DoorOpen",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectCabinetSmallOpen')
     ActionSeq(1)=(AnimationName="DoorClose",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectCabinetSmallClose')
     Mesh=SkeletalMesh'DOTZASearchable.MedicineCabinetDoor'
}
