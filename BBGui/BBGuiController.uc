// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 *
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    Sept 2003
 */
class BBGuiController extends GUIController;

var float LastMenu;

event GUIFont GetMenuFont(string FontName){

   switch (FontName){
      case "BigGuiFont":
      return FontStack[6];
      break;

      case "PlainGuiFont":
      return FontStack[7];
      break;

      case "BoldGuiFont":
      return FontStack[8];
      break;

      case "PlainSmGuiFont":
      return FontStack[9];
      break;

      case "PlainMedGuiFont":
      return FontStack[10];
      break;

      //XBOX
      case "XPlainSmFont":
      return FontStack[11];
      break;

      case "XBoxBigFont":
      return FontStack[12];
      break;

      case "XPlainMedFont":
      return FontStack[13];
      break;

      case "XPlainLittleFont":
      return FontStack[14];
      break;

   }

   if (bIsConsole){
      return FontStack[13];
   } else {
      return FontStack[10];
   }
    /*
   //HUD
BBLargeFont
   FontStack(14)

BBSmallFont
  FontStack(15)
           */

/*


   } else {
      return FontStack[6];
   }
*/
}

/*
event GUIPage CreateMenu(string NewMenuName){

}
*/

/*
event bool OpenMenu(string NewMenuName,
                    optional string Param1, optional string Param2){
   LastMenu = ViewPortOwner.Actor.Level.TimeSeconds;
   Super.OpenMenu(NewMenuName, Param1, Param2);
}

event bool CloseMenu(optional bool bCanceled){
   if (ViewPortOwner.Actor.Level.TimeSeconds - LastMenu < 0.5){
      return false;
   } else {
      return Super.CloseMenu(bCanceled);
   }
}
*/

function int GetMenuStackSize ()
{
    return MenuStack.Length;
}

function CloseAll(bool bCancel)
{
    super.CloseAll(bCancel);
    Log("Close All");
}

function bool CheckTop (name menu)
{
    if (MenuStack.Length <= 0)
        return false;

    return self.TopPage().IsA(menu);
}

function bool CloseAllBut (int leave_num)
{
    while (MenuStack.Length>leave_num)
        CloseMenu(false);
    return true;
}

function bool CloseSome(int n)
{
    local int i;

    for (i = 0; i < n && MenuStack.Length>0; ++i)
        CloseMenu(false);

    return true;
}

function bool SwitchMenu (string menu, optional string Param1, optional string Param2)
{
    Log("Switch to " $ menu);
    CloseMenu(false);
    return OpenMenu(menu, Param1, Param2);
}

defaultproperties
{
     FontStack(0)=fntMenuFont'GUI.GUIController.GUIMenuFont'
     FontStack(1)=fntDefaultFont'GUI.GUIController.GUIDefaultFont'
     FontStack(2)=fntLargeFont'GUI.GUIController.GUILargeFont'
     FontStack(3)=fntHeaderFont'GUI.GUIController.GUIHeaderFont'
     FontStack(4)=fntSmallFont'GUI.GUIController.GUISmallFont'
     FontStack(5)=fntSmallHeaderFont'GUI.GUIController.GUISmallHeaderFont'
     FontStack(6)=BBBigGuiFont'BBGui.BBGuiController.font_1'
     FontStack(7)=BBPlainGuiFont'BBGui.BBGuiController.font_2'
     FontStack(8)=BBBoldGuiFont'BBGui.BBGuiController.font_3'
     FontStack(9)=BBPlainSmGuiFont'BBGui.BBGuiController.font_4'
     FontStack(10)=BBPlainMedGuiFont'BBGui.BBGuiController.font_5'
     FontStack(11)=BBXboxPlainSmFont'BBGui.BBGuiController.font_6'
     FontStack(12)=BBXboxBigFont'BBGui.BBGuiController.font_7'
     FontStack(13)=BBXboxPlainMedFont'BBGui.BBGuiController.font_8'
     FontStack(14)=BBXboxPlainLittleFont'BBGui.BBGuiController.font_11'
     FontStack(15)=BBLargeFont'BBGui.BBGuiController.font_9'
     FontStack(16)=BBSmallFont'BBGui.BBGuiController.font_10'
     StyleNames(0)="GUI.STY_RoundButton"
     StyleNames(1)="GUI.STY_RoundScaledButton"
     StyleNames(2)="GUI.STY_SquareButton"
     StyleNames(3)="GUI.STY_ListBox"
     StyleNames(4)="GUI.STY_ScrollZone"
     StyleNames(5)="GUI.STY_TextButton"
     StyleNames(6)="GUI.STY_Header"
     StyleNames(7)="GUI.STY_Footer"
     StyleNames(8)="GUI.STY_TabButton"
     StyleNames(9)="GUI.STY_NoBackground"
     StyleNames(10)="GUI.STY_SliderCaption"
     StyleNames(11)="GUI.STY_SquareBar"
     StyleNames(12)="GUI.STY_TextLabel"
     StyleNames(13)="GUI.STY_ComboListBox"
     StyleNames(14)="BBGui.STY_BBRoundButton"
     StyleNames(15)="BBGui.STY_BBRoundListButton"
     StyleNames(16)="BBGui.STY_BBHorizontalBar"
     StyleNames(17)="BBGui.STY_BBSquareButton"
     StyleNames(18)="BBGui.STY_BBSlider"
     StyleNames(19)="BBGui.STY_BBHeader"
     StyleNames(20)="BBGui.STY_BBFooter"
     StyleNames(21)="BBGui.STY_BBTextButton"
     StyleNames(22)="BBGui.STY_BBTextButtonBorder"
     StyleNames(23)="BBGui.STY_BBTabButton"
     StyleNames(24)="BBGui.STY_BBThumbnailBox"
     StyleNames(25)="BBGui.STY_BBNoBackground"
     StyleNames(26)="BBGui.STY_BBRoundButtonStatic"
     StyleNames(27)="BBGui.STY_BBRoundReadable"
     StyleNames(28)="BBGui.STY_BBHorizontalBarSolid"
     StyleNames(29)="BBGui.STY_BBListButton"
     StyleNames(30)="BBGui.STY_BBXTextButton"
     StyleNames(31)="BBGui.STY_BBXSquareButton"
     StyleNames(32)="BBGui.STY_BBXRoundButtonStatic"
     StyleNames(33)="BBGui.STY_BBXRoundReadable"
     StyleNames(34)="BBGui.STY_BBXTextButtonBorder"
     StyleNames(35)="BBGui.STY_BBXTextStatic"
     StyleNames(36)="BBGui.STY_BBXInvisible"
     StyleNames(37)="BBGui.STY_BBXInvisibleSm"
     MouseCursors(0)=Texture'GUIContent.Menu.MouseCursor'
     MouseCursors(1)=Texture'GUIContent.Menu.MouseCursor'
     MouseCursors(2)=Texture'GUIContent.Menu.MouseCursor'
     MouseCursors(3)=Texture'GUIContent.Menu.MouseCursor'
     MouseCursors(4)=Texture'GUIContent.Menu.MouseCursor'
     MouseCursors(5)=Texture'GUIContent.Menu.MouseCursor'
     MouseCursors(6)=Texture'GUIContent.Menu.MouseCursor'
     MenuMouseSens=0.700000
}
