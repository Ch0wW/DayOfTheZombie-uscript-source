// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class SubActionCameraEffect extends MatSubAction
	native
	noexport
	collapsecategories;

var() editinline CameraEffect	CameraEffect;
var() float						StartAlpha,
								EndAlpha;
var() bool						DisableAfterDuration;

defaultproperties
{
     EndAlpha=1.000000
     Icon=Texture'Engine.SubActionFade'
     Desc="Camera effect"
}
