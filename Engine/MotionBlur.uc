// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class MotionBlur extends CameraEffect
	native
	noexport
	editinlinenew
	collapsecategories;

var() byte		BlurAlpha;

var const int	RenderTargets[2];
var const float	LastFrameTime;

defaultproperties
{
     BlurAlpha=8
}
