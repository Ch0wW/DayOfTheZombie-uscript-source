// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZProfileNeedOneProfile extends XDOTZErrorPage;

var sound ClickSound;

// Error string
var localized string error_string;

/*****************************************************************
 * Opened
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);

   AddSelectButton (continue_string);
   SetErrorCaption(error_string);
}

/*****************************************************************
 * This gets called every 1/2 second
 *****************************************************************
 */

function Periodic()
{

    // CARROT: hack to get the page behind updating
    if (Controller.MenuStack.Length >= 2)
        Controller.MenuStack[Controller.MenuStack.Length-2].Timer();
}

/*****************************************************************
 * Button A pressed
 *****************************************************************
 */

function DoButtonA ()
{
    Controller.CloseMenu (false);
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
     error_string="At least one profile must be created in order to continue. Press A to continue."
     period=0.100000
     __OnKeyEvent__Delegate=XDOTZProfileNeedOneProfile.HandleKeyEvent
}
