// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZLiveComplaintConfirmBase extends XDOTZErrorPage;

var sound ClickSound;

// Params
var string Gamertag;
var string Xuid;

// Error string
var localized string error_string;

/*****************************************************************
 * Opened
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);

   AddBackButton(cancel_string);
   AddSelectButton (accept_string);

   SetErrorCaption(error_string);
}

/*****************************************************************
 * HandleParameters
 * When open menu get's called, the parameter values are supplied
 * here.
 *
 * Param1 - the menu to load
 * Param2 - the name of the sub menu to load on top of the first menu
 *****************************************************************
 */
event HandleParameters( String param1, String param2 ) {
    super.HandleParameters(param1, param2);

    Gamertag = param1;
    Xuid = param2;
}

/*****************************************************************
 * Button A pressed
 *****************************************************************
 */

function DoButtonA ()
{

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
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     error_string="Are you sure you want to send the complaint? Press A to accept or B to cancel."
     __OnKeyEvent__Delegate=XDOTZLiveComplaintConfirmBase.HandleKeyEvent
}
