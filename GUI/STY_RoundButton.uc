// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
//
//	Normal push buttons (OK, Cancel, Apply)
// ====================================================================

class STY_RoundButton extends GUIStyles;

defaultproperties
{
     KeyName="RoundButton"
     Images(0)=Texture'GUIContent.Menu.BorderBoxD'
     Images(1)=Texture'GUIContent.Menu.ButtonWatched'
     Images(2)=FinalBlend'GUIContent.Menu.ButtonBigPulse'
     Images(3)=FinalBlend'GUIContent.Menu.fbPlayerHighlight'
     Images(4)=Texture'GUIContent.Menu.BorderBoxD'
     FontColors(2)=(B=0,G=200,R=230)
     FontColors(3)=(B=0,G=0,R=0)
     FontNames(0)="SmallHeaderFont"
     FontNames(1)="SmallHeaderFont"
     FontNames(2)="SmallHeaderFont"
     FontNames(3)="SmallHeaderFont"
     FontNames(4)="SmallHeaderFont"
}
