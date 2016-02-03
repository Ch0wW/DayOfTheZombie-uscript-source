// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
//
//	Style content for all GUI tabs
// ====================================================================

class STY_TabButton extends GUIStyles;

defaultproperties
{
     KeyName="TabButton"
     Images(0)=Texture'GUIContent.Menu.BoxTab'
     Images(1)=Texture'GUIContent.Menu.BoxTabWatched'
     Images(2)=FinalBlend'GUIContent.Menu.BoxTabPulse'
     Images(3)=Texture'GUIContent.Menu.BoxTab'
     FontColors(2)=(B=0,G=200,R=230)
     FontColors(3)=(B=0,G=200,R=230)
     FontNames(0)="SmallHeaderFont"
     FontNames(1)="SmallHeaderFont"
     FontNames(2)="SmallHeaderFont"
     FontNames(3)="SmallHeaderFont"
     FontNames(4)="SmallHeaderFont"
}
