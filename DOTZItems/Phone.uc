// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class Phone extends ActionableStaticMesh
placeable;

defaultproperties
{
     ActionMessage="Press Action to use phone"
     ActionSound=Sound'DOTZXActionObjects.Phone.busy'
     ActionMesh=StaticMesh'DOTZSObjects.Decoration.PhoneB'
     MeshAction=MA_TOGGLE
     SoundAction=SA_TOGGLE_AMBIENT
     StaticMesh=StaticMesh'DOTZSObjects.Decoration.Phone'
     PrePivot=(X=-1.000000,Z=10.000000)
}
