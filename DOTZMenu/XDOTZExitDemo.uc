// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZExitDemo - exits the demo
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #1 $
 * @date    June 23, 2005
 */
class XDOTZExitDemo extends XDOTZErrorPage;


var localized string QuitMessage;
var localized string Quit_string;

/*****************************************************************
 * Opened
 *****************************************************************
 */
event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);
  AddBackButton(cancel_string);
  AddSelectButton(quit_string);
  SetErrorCaption(QuitMessage);
}


/*****************************************************************
 * DoButtonA
 *****************************************************************
 */
function DoButtonA(){
    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
   //class'UtilsXbox'.static.Set_Reboot_Type(6);   // IS_RETURN_FROM_SINGLE_PLAYER
   // Display loading screen
   //Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu");
   // Reboot!
   //Console(Controller.Master.Console).ConsoleCommand("reboot");  // URL not part of command on xbox
   //Controller.ConsoleCommand("Quit");
   Controller.OpenMenu("DOTZMenu.XDOTZExitScreenDemo");
}

/*****************************************************************
 * DoButtonB
 *****************************************************************
 */
function DoButtonB(){
   Controller.CloseMenu(false);
}


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     QuitMessage="Are you sure you wish to exit the demo?"
     quit_string="Exit"
     __OnKeyEvent__Delegate=XDOTZExitDemo.HandleKeyEvent
}
