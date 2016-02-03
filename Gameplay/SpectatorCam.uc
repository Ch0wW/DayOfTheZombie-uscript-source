// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// SpectatorCam.
//=============================================================================
class SpectatorCam extends KeyPoint;

var() bool bSkipView; // spectators skip this camera when flipping through cams
var() float FadeOutTime;	// fade out time if used as EndCam

defaultproperties
{
     FadeOutTime=5.000000
     bClientAnim=True
     bDirectional=True
     Texture=Texture'Engine.S_Camera'
     CollisionRadius=20.000000
     CollisionHeight=40.000000
}
