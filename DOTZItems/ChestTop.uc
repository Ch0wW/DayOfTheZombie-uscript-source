// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ChestTop extends ActionableSkeletalMesh;

defaultproperties
{
     ActionMessage="Press Action to search chest"
     ActionSeq(0)=(AnimationName="ChestOpen",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectChestOpen')
     ActionSeq(1)=(AnimationName="ChestClose",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectChestClose')
     Mesh=SkeletalMesh'DOTZASearchable.ChestTop'
}
