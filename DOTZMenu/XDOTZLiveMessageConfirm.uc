// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZLiveMessageConfirm extends XDOTZErrorPage;

var sound ClickSound;

// Error string
var localized string error_string;

/*****************************************************************
 * Opened
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);

   SetErrorCaption(error_string);
   AddBackButton(cancel_string);
   AddSelectButton (continue_string);
}

/*****************************************************************
 * Button A pressed
 *****************************************************************
 */

function DoButtonA ()
{
    class'UtilsXbox'.static.Do_Message_Check();
}

/*****************************************************************
 * Button B pressed
 *****************************************************************
 */

function DoButtonB ()
{
    Controller.CloseMenu (true);
}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     error_string="You are about to leave the game and enter the Xbox Dashboard. Do you wish to continue?"
     __OnKeyEvent__Delegate=XDOTZLiveMessageConfirm.HandleKeyEvent
}
