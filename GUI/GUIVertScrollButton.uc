// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUIVertScrollButton
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUIVertScrollButton extends GUIGFXButton
		Native;

#exec OBJ LOAD FILE=GUIContent.utx

var(Menu)	bool	UpButton;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);

	if (UpButton)
		Graphic = Material'GUIContent.Menu.ArrowBlueUp';
	else
		Graphic = Material'GUIContent.Menu.ArrowBlueDown';
}

defaultproperties
{
     Position=ICP_Scaled
     StyleName="RoundScaledButton"
     bNeverFocus=True
}
