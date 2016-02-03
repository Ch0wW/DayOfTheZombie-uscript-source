// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUIHorzScrollButton
//  Parent: GUI.GUIGFXButton
//
//  <Enter a description here>
// ====================================================================

class GUIHorzScrollButton extends GUIGFXButton
		Native;

#exec OBJ LOAD FILE=GUIContent.utx

var(Menu)	bool	LeftButton;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);
	
	if (LeftButton)
		Graphic = Material'GUIContent.Menu.ArrowBlueLeft';
	else
		Graphic = Material'GUIContent.Menu.ArrowBlueRight';
}

defaultproperties
{
     Position=ICP_Scaled
     StyleName="RoundScaledButton"
     bNeverFocus=True
}
