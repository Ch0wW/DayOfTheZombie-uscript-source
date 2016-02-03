// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 *
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    Oct 2003
 */
class BBXListBox extends GuiListBox;

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
         StyleName="BBXInvisible"
         Name="TheList"
     End Object
     List=GUIList'BBGui.BBXListBox.TheList'
     Begin Object Class=GUIVertScrollBar Name=TheScrollbar
         Begin Object Class=GUIVertScrollZone Name=ScrollZone
             StyleName="BBXSquareButton"
             Name="ScrollZone"
         End Object
         MyScrollZone=GUIVertScrollZone'BBGui.BBXListBox.ScrollZone'
         Begin Object Class=BBVertScrollButton Name=UpBut
             UpButton=True
             StyleName="BBXSquareButton"
             Name="UpBut"
         End Object
         MyUpButton=BBVertScrollButton'BBGui.BBXListBox.UpBut'
         Begin Object Class=BBVertScrollButton Name=DownBut
             StyleName="BBXSquareButton"
             Name="DownBut"
         End Object
         MyDownButton=BBVertScrollButton'BBGui.BBXListBox.DownBut'
         Begin Object Class=GUIVertGripButton Name=Grip
             StyleName="BBXSquareButton"
             Name="Grip"
         End Object
         MyGripButton=GUIVertGripButton'BBGui.BBXListBox.Grip'
         StyleName="BBXSquareButton"
         bVisible=False
         Name="TheScrollbar"
     End Object
     MyScrollBar=GUIVertScrollBar'BBGui.BBXListBox.TheScrollbar'
}
