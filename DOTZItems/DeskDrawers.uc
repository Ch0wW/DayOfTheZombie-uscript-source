// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class DeskDrawers extends ActionableSkeletalMesh;

defaultproperties
{
     ActionMessage="Press Action to search desk"
     ActionSeq(0)=(AnimationName="TopDrawerOpen",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectDrawerWoodOpen')
     ActionSeq(1)=(AnimationName="TopDrawerClose",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectDrawerWoodClose')
     ActionSeq(2)=(AnimationName="BottomDrawerOpen",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectDrawerWoodOpen')
     ActionSeq(3)=(AnimationName="BottomDrawerClose",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectDrawerWoodClose')
     Mesh=SkeletalMesh'DOTZASearchable.DeskDrawers'
}
