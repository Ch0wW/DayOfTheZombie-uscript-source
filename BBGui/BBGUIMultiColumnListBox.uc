// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BBGUIMultiColumnListBox extends GUIMultiColumnListBox;

function InitComponent(GuiController MyController, GUIComponent MyOwner){
   super.InitComponent(MyController, MyOwner);
   MyScrollBar.SetVisibility(false);
}

defaultproperties
{
     Begin Object Class=GUIMultiColumnList Name=TheList
         StyleName="BBListButton"
         Name="TheList"
     End Object
     List=GUIMultiColumnList'BBGui.BBGUIMultiColumnListBox.TheList'
     Begin Object Class=GUIVertScrollBar Name=TheScrollbar
         Begin Object Class=GUIVertScrollZone Name=ScrollZone
             StyleName="BBSquareButton"
             Name="ScrollZone"
         End Object
         MyScrollZone=GUIVertScrollZone'BBGui.BBGUIMultiColumnListBox.ScrollZone'
         Begin Object Class=BBVertScrollButton Name=UpBut
             UpButton=True
             Name="UpBut"
         End Object
         MyUpButton=BBVertScrollButton'BBGui.BBGUIMultiColumnListBox.UpBut'
         Begin Object Class=BBVertScrollButton Name=DownBut
             Name="DownBut"
         End Object
         MyDownButton=BBVertScrollButton'BBGui.BBGUIMultiColumnListBox.DownBut'
         Begin Object Class=GUIVertGripButton Name=Grip
             StyleName="BBSquareButton"
             Name="Grip"
         End Object
         MyGripButton=GUIVertGripButton'BBGui.BBGUIMultiColumnListBox.Grip'
         StyleName="BBSquareButton"
         Name="TheScrollbar"
     End Object
     MyScrollBar=GUIVertScrollBar'BBGui.BBGUIMultiColumnListBox.TheScrollbar'
}
