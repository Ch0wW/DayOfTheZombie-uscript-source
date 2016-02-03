// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZSLNoNetworkCable extends XDOTZErrorPage;

var sound ClickSound;

// Error string
var localized string error_string;

/*****************************************************************
 * Opened
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);

   class'UtilsXbox'.static.Sign_Out();

   SetErrorCaption(error_string);
   AddBackButton(cancel_string);
   AddSelectButton (troubleshooter_string);
}

/*****************************************************************
 * Button A pressed
 *****************************************************************
 */

function DoButtonA ()
{
    Controller.OpenMenu("DOTZMenu.XDOTZSLNoNetworkCableConfirm");
}

/*****************************************************************
 * Button B pressed
 *****************************************************************
 */

function DoButtonB ()
{
    local int reboot_type;
    reboot_type = class'UtilsXbox'.static.Get_Reboot_Type();

    if (reboot_type > 0 && reboot_type < 6) {
        /*if (reboot_type == 3 || reboot_type == 4)
            class'UtilsXbox'.static.Set_Reboot_Type(8);   // IS_RETURN_FROM_LIVE_MATCH
        else if (reboot_type == 1 || reboot_type == 2)
            class'UtilsXbox'.static.Set_Reboot_Type(7);   // IS_RETURN_FROM_SL_MATCH
        else*/
            class'UtilsXbox'.static.Set_Reboot_Type(6);   // IS_RETURN_FROM_SINGLE_PLAYER

        // Display loading screen
        Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu");

        // Reboot!
        Console(Controller.Master.Console).ConsoleCommand("reboot");  // URL not part of command on xbox
    } else {
        BBGuiController(Controller).CloseTo ('XDOTZMainMenu');
    }
}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     error_string="The network cable might be disconnected. Please check the cable and try again."
     __OnKeyEvent__Delegate=XDOTZSLNoNetworkCable.HandleKeyEvent
}
