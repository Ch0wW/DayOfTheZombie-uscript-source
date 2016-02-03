// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class FileCabinet extends ActionableSkeletalMesh;

defaultproperties
{
     ActionMessage="Press Action to search cabinet"
     ActionSeq(0)=(AnimationName="TopDrawerOpen",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectFileCabinetOpen')
     ActionSeq(1)=(AnimationName="TopDrawerClose",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectFileCabinetClose')
     ActionSeq(2)=(AnimationName="BottomDrawerOpen",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectFileCabinetOpen')
     ActionSeq(3)=(AnimationName="BottomDrawerClose",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectFileCabinetClose')
     Mesh=SkeletalMesh'DOTZASearchable.FileCabinetADrawers'
}
