// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class AnimNotify_Effect extends AnimNotify
	native;

var() class<Actor> EffectClass;
var() name Bone;
var() vector OffsetLocation;
var() rotator OffsetRotation;
var() bool Attach;
var() name Tag;
var() float DrawScale;
var() vector DrawScale3D;

var private transient Actor LastSpawnedEffect;	// Valid only in the editor.

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

cpptext
{
	// AnimNotify interface.
	virtual void Notify( UMeshInstance *Instance, AActor *Owner );

}


defaultproperties
{
     DrawScale=1.000000
     DrawScale3D=(X=1.000000,Y=1.000000,Z=1.000000)
}
