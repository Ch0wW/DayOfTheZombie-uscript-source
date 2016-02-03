// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUIGFXButton
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUICheckBoxButton extends GUIGFXButton
	Native;


function string LoadINI()
{
	local string s;

	s = Super.LoadINI();

	if (S=="")
		return s;

	bChecked = bool(s);
	return s;
}

function SaveINI(string Value)
{
	Super.SaveINI(""$bChecked);
}

defaultproperties
{
     Graphic=Texture'GUIContent.Menu.CheckBoxMark'
     Position=ICP_Scaled
     bCheckBox=True
     bRepeatClick=False
     bTabStop=True
}
