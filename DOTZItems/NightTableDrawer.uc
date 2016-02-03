// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class NightTableDrawer extends ActionableSkeletalMesh;

defaultproperties
{
     ActionMessage="Press Action to search night table"
     ActionSeq(0)=(AnimationName="DrawerOpen",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectDrawerWoodOpen')
     ActionSeq(1)=(AnimationName="DrawerClose",AnimationSound=Sound'DOTZXActionObjects.SearchableObjects.SearchableObjectDrawerWoodClose')
     Mesh=SkeletalMesh'DOTZASearchable.NightTableDrawer'
}
