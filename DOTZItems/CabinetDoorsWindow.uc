// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class CabinetDoorsWindow extends ActionableSkeletalMesh;

defaultproperties
{
     ActionMessage="Press Action to search cabinet"
     ActionSeq(0)=(AnimationName="DoorsOpen",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectCabinetMetalOpen')
     ActionSeq(1)=(AnimationName="DoorsClose",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectCabinetMetalClose')
     Mesh=SkeletalMesh'DOTZASearchable.CabinetDoorsWindow'
}
