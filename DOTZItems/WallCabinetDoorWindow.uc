// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class WallCabinetDoorWindow extends ActionableSkeletalMesh;

defaultproperties
{
     ActionMessage="Press Action to search cabinet"
     ActionSeq(0)=(AnimationName="DoorsOpen",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectChestOpen')
     ActionSeq(1)=(AnimationName="DoorsClose",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectChestClose')
     Mesh=SkeletalMesh'DOTZASearchable.WallCabinetDoorWindow'
}
