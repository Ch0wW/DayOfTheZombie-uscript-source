// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZCrossTitleWarning extends XDOTZErrorPage;

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

   AddBackButton (cancel_string);
}

/*****************************************************************
 * HandleParameters
 * When open menu get's called, the parameter values are supplied
 * here.
 *
 * Param1 - the title
 *****************************************************************
 */
event HandleParameters( String param1, String param2 ) {
    SetErrorCaption(error_string1 $ " " $ param1 $ " " $ error_string2);
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
    Controller.CloseMenu (false);
}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     error_string1="Your progress will be lost if you continue. Please insert the disc for"
     error_string2="to continue. Press B to cancel."
     __OnKeyEvent__Delegate=XDOTZCrossTitleWarning.HandleKeyEvent
}
