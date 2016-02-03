// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * 
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    Sept 2003
 */
class BBGuiScrollTextBox extends GuiScrollTextBox;

defaultproperties
{
     Begin Object Class=GUIScrollText Name=TheText
         StyleName="BBPlainGuiFont"
         bAcceptsInput=False
         bNeverFocus=True
         Name="TheText"
     End Object
     MyScrollText=GUIScrollText'BBGui.BBGuiScrollTextBox.TheText'
     Begin Object Class=GUIVertScrollBar Name=TheScrollbar
         Begin Object Class=GUIVertScrollZone Name=ScrollZone
             StyleName="BBSquareButton"
             Name="ScrollZone"
         End Object
         MyScrollZone=GUIVertScrollZone'BBGui.BBGuiScrollTextBox.ScrollZone'
         Begin Object Class=BBVertScrollButton Name=UpBut
             UpButton=True
             Name="UpBut"
         End Object
         MyUpButton=BBVertScrollButton'BBGui.BBGuiScrollTextBox.UpBut'
         Begin Object Class=BBVertScrollButton Name=DownBut
             Name="DownBut"
         End Object
         MyDownButton=BBVertScrollButton'BBGui.BBGuiScrollTextBox.DownBut'
         Begin Object Class=GUIVertGripButton Name=Grip
             StyleName="BBRoundButton"
             Name="Grip"
         End Object
         MyGripButton=GUIVertGripButton'BBGui.BBGuiScrollTextBox.Grip'
         StyleName="BBRoundButton"
         bVisible=False
         WinWidth=0.025000
         Name="TheScrollbar"
     End Object
     MyScrollBar=GUIVertScrollBar'BBGui.BBGuiScrollTextBox.TheScrollbar'
}
