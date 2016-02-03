// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZCrossTitleCheck extends XDOTZErrorPage;

var sound ClickSound;

// Error string
var localized string error_string1;
var localized string error_string2;
var localized string alternate_param_1;

var string to_string;
var string from_string;

/*****************************************************************
 * Opened
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);

   AddBackButton (cancel_string);
   AddSelectButton (join_string);
}

/*****************************************************************
 * HandleParameters
 * When open menu get's called, the parameter values are supplied
 * here.
 *
 * Param1 - from
 * Param2 - to
 *****************************************************************
 */
event HandleParameters( String param1, String param2 ) {
    if (param1 == "")
        SetErrorCaption(alternate_param_1 $ " " $ error_string1 $ " " $ param2 $ error_string2);
    else
        SetErrorCaption(param1 $ " " $ error_string1 $ " " $ param2 $ error_string2);
}

/*****************************************************************
 * Button A pressed
 *****************************************************************
 */

function DoButtonA ()
{
    BBGuiController(Controller).SwitchMenu ("DOTZMenu.XDOTZLiveSignInCross");
}

/*****************************************************************
 * Button B pressed
 *****************************************************************
 */

function DoButtonB ()
{
    Controller.CloseMenu (false);
}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     error_string1="accepted an invite from"
     error_string2=". Press A to Join or B to cancel."
     alternate_param_1="You"
     __OnKeyEvent__Delegate=XDOTZCrossTitleCheck.HandleKeyEvent
}
