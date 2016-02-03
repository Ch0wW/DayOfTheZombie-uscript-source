// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZLiveMultiplayer
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZLiveGettingMatchCross extends XDOTZLivePage;



//Page components
var Automated GUILabel   MessageLabel;
var Automated GUILabel   DotDotDotLabel;

var string    ErrorMenu;
var string    QuickMatchMenu;
var string    NoSessionsMenu;

//configurable stuff
var localized string PageCaption;

var bool DoneTrying;
var int DotDotDot;

var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner )
{
   Super.Initcomponent(MyController, MyOwner);
   // init my components...

   SetPageCaption (PageCaption);
   AddBackButton();
}

/*****************************************************************
 * This gets called every 1/2 second
 *****************************************************************
 */

function Periodic ()
{
    local int error;

    super.Periodic();

    // if we have failed already
    if (DoneTrying)
        return;

    // Pump the sign in

    // NOTE: Match_Refresh can be called even if we are doing optimatch
    // stuff as long as Match_Refresh_Criteria was called before.

    DoneTrying = !class'UtilsXbox'.static.Cross_Refresh_Pump();

    // Check for live sign in errors
    error = class'UtilsXbox'.static.Get_Last_Error();
    Log("Getting matches error " $ error);

    // Check for CALL_AGAIN
    if (error > 0) {
        Log("Getting matches produced a real error");
        BBGuiController(Controller).SwitchMenu(ErrorMenu);
    } else if (DoneTrying) {
        // Currently viewd session is already selected
        // so all we have to do is reboot.

        class'UtilsXbox'.static.Set_Reboot_Type(4);   // Is live client

        // Display loading screen
        //Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu");

        // Not joining a friend
        class'UtilsXbox'.static.Live_Client_Set_Joining_Friend(false);
        class'UtilsXbox'.static.Live_Client_Set_Joining_Cross(true);

        // Reboot!
        //Console(Controller.Master.Console).ConsoleCommand("reboot");  // URL not part of command on xbox

        // 0.0.0.0 Gets replaced with the real IP after reboot
        BBGuiController(Controller).SwitchMenu("DOTZMenu.XDOTZCharacterSelect", "0.0.0.0"
                //$ "?XGAMERTAG=" $ EncodeStringURL(class'UtilsXbox'.static.Get_Current_Name())
                //$ "?XUID=" $ class'UtilsXbox'.static.Get_Current_ID()
                //$ "?XNADDR=" $ class'UtilsXbox'.static.Get_Current_Address()
            );

    }



    ++DotDotDot;
    if (DotDotDot >= 10) {
        DotDotDotLabel.Caption = DotDotDotLabel.Caption $ ".";
        DotDotDot = 0;
    }
}

/*****************************************************************
 * B Button pressed
 *
 *****************************************************************
 */

function DoButtonB ()
{
    DoneTrying = false;
    class'UtilsXbox'.static.Cross_Cancel_Refresh();
    BBGuiController(Controller).CloseMenu (True);
    Log("Getting matches in cancelled");
}

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
    super.Opened(Sender);
    Log("Getting matches in started");
    class'UtilsXbox'.static.Cross_Refresh();
    DoneTrying = false;
}

/*****************************************************************
 * Closed
 *****************************************************************
 */

event Closed(GUIComponent Sender, bool bCancelled) {
   Super.Closed(Sender,bCancelled);
   Controller.MouseEmulation(false);
}

/*****************************************************************
 * NotifyLevelChange
 *****************************************************************
 */

event NotifyLevelChange()
{
    Controller.CloseMenu(true);
}

/*****************************************************************
 * default properties
 *****************************************************************
 */

defaultproperties
{
     Begin Object Class=GUILabel Name=MessageLabel_lbl
         Caption="Getting cross title match. Press B to Cancel."
         TextAlign=TXTA_Center
         TextFont="XPlainMedFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.800000
         RenderWeight=0.900000
         Name="MessageLabel_lbl"
     End Object
     MessageLabel=GUILabel'DOTZMenu.XDOTZLiveGettingMatchCross.MessageLabel_lbl'
     Begin Object Class=GUILabel Name=DotDotDotLabel_lbl
         Caption="."
         TextAlign=TXTA_Center
         TextFont="XPlainMedFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.800000
         RenderWeight=0.900000
         Name="DotDotDotLabel_lbl"
     End Object
     DotDotDotLabel=GUILabel'DOTZMenu.XDOTZLiveGettingMatchCross.DotDotDotLabel_lbl'
     ErrorMenu="DOTZMenu.XDOTZLiveError"
     NoSessionsMenu="DOTZMenu.XDOTZLiveNoSessionsError"
     PageCaption="Sign In"
     ClickSound=Sound'DOTZXInterface.Select'
     period=0.050000
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLiveGettingMatchCross.HandleKeyEvent
}
