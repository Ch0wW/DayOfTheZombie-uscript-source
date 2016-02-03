// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  XInterface.STY_ListBox
//  Parent: XInterface.STY_SquareButton
//
//  Background style for the actual combo area of the listbox
//	i.e. when the menu is not expanded (I think ?)
// ====================================================================
class STY_ComboListBox extends STY_ListBox;

defaultproperties
{
     KeyName="ComboListBox"
     Images(0)=Texture'GUIContent.Menu.EditBoxDown'
     Images(1)=Texture'GUIContent.Menu.EditBoxDown'
     Images(2)=Texture'GUIContent.Menu.EditBoxDown'
     Images(3)=Texture'GUIContent.Menu.EditBoxDown'
}
