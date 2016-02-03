// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZLiveMultiplayer
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZLiveSigningIn extends XDOTZLivePage;



//Page components
var Automated GUILabel   MessageLabel;
var Automated GUILabel   DotDotDotLabel;

var string MultiplayerMenu;      // Multiplayer menu location
var string ErrorMenu;

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
    DoneTrying = !class'UtilsXbox'.static.Sign_In_Pump();

    // Check for live sign in errors
    error = class'UtilsXbox'.static.Get_Last_Error();
    Log("Signing error " $ error);

    // Check for CALL_AGAIN
    if (error > 0) {
        Log("Signing in produced a real error");
        BBGuiController(Controller).SwitchMenu(ErrorMenu);
    } else if (DoneTrying) {
        Log("Signing in is done");
        //class'UtilsXbox'.static.Reaquire_Addr();
        BBGuiController(Controller).SwitchMenu(MultiplayerMenu);
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
    DoneTrying = true;
    class'UtilsXbox'.static.Cancel_Sign_In();
    BBGuiController(Controller).CloseTo ('XDOTZLiveSignIn');
    Log("Singing in cancelled");
}

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
    local int error;

    super.Opened(Sender);

    // Attempt to sign in to live
    if (class'UtilsXbox'.static.Is_Signed_In())
        class'UtilsXbox'.static.Sign_Out();
    class'UtilsXbox'.static.Attempt_Sign_In();

    // Check if we can continue
    error = class'UtilsXbox'.static.Get_Last_Error();
    if (error > 0) {
        BBGuiController(Controller).SwitchMenu(ErrorMenu);
        DoneTrying = true;
    } else {
        DoneTrying = false;
    }

    Log("Singing in started");
}

/*****************************************************************
 * Closed
 *****************************************************************
 */

event Closed(GUIComponent Sender, bool bCancelled) {
   Super.Closed(Sender,bCancelled);
   Controller.MouseEmulation(false);

   Log("Close Signing in screen...");
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
         Caption="Signing in to Xbox live. Press B to Cancel."
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
     MessageLabel=GUILabel'DOTZMenu.XDOTZLiveSigningIn.MessageLabel_lbl'
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
     DotDotDotLabel=GUILabel'DOTZMenu.XDOTZLiveSigningIn.DotDotDotLabel_lbl'
     MultiplayerMenu="DOTZMenu.XDOTZLiveMultiplayer"
     ErrorMenu="DOTZMenu.XDOTZLiveError"
     PageCaption="Sign In"
     ClickSound=Sound'DOTZXInterface.Select'
     period=0.050000
     bSignInPump=False
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLiveSigningIn.HandleKeyEvent
}
