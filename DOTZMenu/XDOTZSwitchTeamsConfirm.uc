// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZSwitchTeamsConfirm extends XDOTZErrorPage;

var sound ClickSound;

// Error string
var localized string error_string;

// Profiles
//var Profiler profiles;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
   Super.Initcomponent(MyController, MyOwner);
   // init my components...

   //profiles = new(self) class'DOTZProfiler';
}

/*****************************************************************
 * Opened
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);

   AddBackButton(cancel_string);
   AddSelectButton (switch_teams);

   SetErrorCaption(error_string);
}

/*****************************************************************
 * Button A pressed
 *****************************************************************
 */

function DoButtonA ()
{
    PlayerOwner().SwitchTeam();
    Controller.CloseMenu(true);
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
     error_string="Do you really want to switch teams? Press A to confirm or B to cancel."
     __OnKeyEvent__Delegate=XDOTZSwitchTeamsConfirm.HandleKeyEvent
}
