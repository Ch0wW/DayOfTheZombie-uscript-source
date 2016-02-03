// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class TelevisionB extends ActionableStaticMesh
placeable;

defaultproperties
{
     ActionMessage="Press Action to use t.v."
     ActionSound=Sound'DOTZXActionObjects.TV.TVStatic'
     MaterialToSwap=Shader'DOTZTObjects.Decoration.TVStaticShader'
     SoundAction=SA_TOGGLE_AMBIENT
     MaterialAction=MA_TRIGGER
     StaticMesh=StaticMesh'DOTZSObjects.Decoration.TV'
     PrePivot=(X=-1.000000,Z=10.000000)
}
