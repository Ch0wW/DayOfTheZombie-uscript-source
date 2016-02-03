// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZNoController extends XDOTZErrorPage;

var sound ClickSound;

// Error string
var localized string error_string1;
var localized string error_string2;

/*****************************************************************
 * Opened
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);

   SetErrorCaption(error_string1 $ " " $ class'UtilsXbox'.static.Get_Captured_Controller() + 1 $ " " $ error_string2);
   AddSelectButton (continue_string);
}

/*****************************************************************
 * Button A pressed
 *****************************************************************
 */

function DoButtonA ()
{
    if(Controller.MenuStack.Length <= 1)
        AdvancedGameInfo(PlayerOwner().Level.Game).NoMenuPause(false, PlayerOwner());
    BBGUICOntroller(Controller).CloseMenu(true);
}

/*****************************************************************
 * Button B pressed
 *****************************************************************
 */

function DoButtonB ()
{
    Controller.CloseMenu(true);
}

/*****************************************************************
 * Button START pressed
 *****************************************************************
 */
function DoButtonStart(){
    Controller.CloseMenu(true);
}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     error_string1="Please reconnect the controller to controller port"
     error_string2="and press A to continue"
     __OnKeyEvent__Delegate=XDOTZNoController.HandleKeyEvent
}
