// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZKicked extends XDOTZErrorPage;

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
   AddSelectButton (continue_string);
}

/*****************************************************************
 * Fires after a short delay
 *****************************************************************
 */

/*function Periodic()
{
    DoButtonA ();
} */

/*****************************************************************
 * Button A pressed
 *****************************************************************
 */

function DoButtonA ()
{
    local int reboot_type;
    reboot_type = class'UtilsXbox'.static.Get_Reboot_Type();

    Log("Reboot type " $ string(reboot_type));

    // If live, end the game
    if (reboot_type == 3 || reboot_type ==4) {
        class'UtilsXbox'.static.Set_Reboot_Type(8);   // IS_RETURN_FROM_SINGLE_PLAYER

        // Display loading screen
        Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu");

        // Reboot!
        Log("Rebooting...");
        Console(Controller.Master.Console).ConsoleCommand("reboot");  // URL not part of command on xbox
    } else if (reboot_type >0) {
        //Controller.CloseAll(true);

        if (BBGuiController(Controller).GetMenuStackSize() > 2) {
            BBGuiController(Controller).CloseAllBut(1);
        } else {
            Controller.CloseMenu(true);
        }

        // Do nothing
    } else {
        BBGuiController(Controller).CloseTo ('XDOTZMainMenu');
    }
}

/*****************************************************************
 * Button B pressed
 *****************************************************************
 */

function DoButtonB ()
{
    DoButtonA ();
}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     error_string="You were signed out of Xbox Live because another person signed in using your account. Press A to continue."
     __OnKeyEvent__Delegate=XDOTZKicked.HandleKeyEvent
}
