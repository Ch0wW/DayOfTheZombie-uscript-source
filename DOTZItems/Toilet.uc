// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class Toilet extends ActionableStaticMesh
placeable;

defaultproperties
{
     ActionMessage="Press Action to use toilet"
     ActionSound=Sound'DOTZXActionObjects.Toilet.Flush'
     StaticMesh=StaticMesh'DOTZSObjects.Decoration.Toilet'
     PrePivot=(X=-1.000000,Z=10.000000)
     SoundOcclusion=OCCLUSION_None
}
