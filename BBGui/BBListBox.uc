// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 *
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    Oct 2003
 */
class BBListBox extends GuiListBox;

var material selection_material;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);

    List.SelectedImage=selection_material;
}

defaultproperties
{
     selection_material=Texture'BBTGuiContent.General.RoundBox'
     Begin Object Class=GUIList Name=TheList
         StyleName="BBListButton"
         Name="TheList"
     End Object
     List=GUIList'BBGui.BBListBox.TheList'
     Begin Object Class=GUIVertScrollBar Name=TheScrollbar
         Begin Object Class=GUIVertScrollZone Name=ScrollZone
             StyleName="BBSquareButton"
             Name="ScrollZone"
         End Object
         MyScrollZone=GUIVertScrollZone'BBGui.BBListBox.ScrollZone'
         Begin Object Class=BBVertScrollButton Name=UpBut
             UpButton=True
             Name="UpBut"
         End Object
         MyUpButton=BBVertScrollButton'BBGui.BBListBox.UpBut'
         Begin Object Class=BBVertScrollButton Name=DownBut
             Name="DownBut"
         End Object
         MyDownButton=BBVertScrollButton'BBGui.BBListBox.DownBut'
         Begin Object Class=GUIVertGripButton Name=Grip
             StyleName="BBSquareButton"
             Name="Grip"
         End Object
         MyGripButton=GUIVertGripButton'BBGui.BBListBox.Grip'
         StyleName="BBSquareButton"
         bVisible=False
         Name="TheScrollbar"
     End Object
     MyScrollBar=GUIVertScrollBar'BBGui.BBListBox.TheScrollbar'
     StyleName="BBTextButton"
}
