// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZQuitConfirmJoining extends XDOTZQuitConfirm;

/*****************************************************************
 * DoButtonA
 *****************************************************************
 */
function DoButtonA(){
    // Reboot to live client
    class'UtilsXbox'.static.Set_Reboot_Type(4);   // Is live client

    // Display loading screen
    //Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu");

    // Joining a friend
    class'UtilsXbox'.static.Live_Client_Set_Joining_Friend(true);
    class'UtilsXbox'.static.Live_Client_Set_Joining_Cross(false);

    // Reboot!
    //Console(Controller.Master.Console).ConsoleCommand("reboot");  // URL not part of command on xbox
    // 0.0.0.0 Gets replaced with the real IP after reboot
    // PlayerOwner().Level.ServerTravel("0.0.0.0", false);

    Controller.OpenMenu("DOTZMenu.XDOTZCharacterSelect", "0.0.0.0");
}

defaultproperties
{
     __OnKeyEvent__Delegate=XDOTZQuitConfirmJoining.HandleKeyEvent
}
