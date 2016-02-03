// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZLiveMultiplayer
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZLiveGettingMatches extends XDOTZLivePage;



//Page components
var Automated GUILabel   MessageLabel;
var Automated GUILabel   DotDotDotLabel;

var string    ErrorMenu;
var string    QuickMatchMenu;
var string    NoSessionsMenu;

var string    NextMenu;

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
    local int num_sessions;

    super.Periodic();

    // if we have failed already
    if (DoneTrying)
        return;

    // Pump the sign in

    // NOTE: Match_Refresh can be called even if we are doing optimatch
    // stuff as long as Match_Refresh_Criteria was called before.

    DoneTrying = !class'UtilsXbox'.static.Match_Refresh_Pump();

    // Check for live sign in errors
    error = class'UtilsXbox'.static.Get_Last_Error();
    Log("Getting matches error " $ error);

    // Check for CALL_AGAIN
    if (error > 0) {
        Log("Getting matches produced a real error");
        BBGuiController(Controller).SwitchMenu(ErrorMenu);
    } else if (DoneTrying) {

        // Check number of sessions
        num_sessions = class'UtilsXbox'.static.Match_Get_Num_Sessions ();
        if (num_sessions <= 0) {
            BBGuiController(Controller).SwitchMenu (NoSessionsMenu);
        } else {
            BBGuiController(Controller).SwitchMenu (NextMenu);
        }
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
    class'UtilsXbox'.static.Match_Cancel_Refresh();
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
    DoneTrying = false;
}

/*****************************************************************
 * HandleParameters
 * Collect the URL from the calling page
 *****************************************************************
 */

event HandleParameters( String param1, String param2 ) {
   NextMenu = Param1;
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
         Caption="Getting list of available matches. Press B to Cancel."
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
     MessageLabel=GUILabel'DOTZMenu.XDOTZLiveGettingMatches.MessageLabel_lbl'
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
     DotDotDotLabel=GUILabel'DOTZMenu.XDOTZLiveGettingMatches.DotDotDotLabel_lbl'
     ErrorMenu="DOTZMenu.XDOTZLiveError"
     NoSessionsMenu="DOTZMenu.XDOTZLiveNoSessionsError"
     PageCaption="Sign In"
     ClickSound=Sound'DOTZXInterface.Select'
     period=0.050000
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLiveGettingMatches.HandleKeyEvent
}
