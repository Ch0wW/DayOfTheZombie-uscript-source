// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//  XDOTZErrorPage - Base class for error pages
//-----------------------------------------------------------

class XDOTZErrorPage extends XDOTZPageBase;

var automated GUIButton  ErrorBackground;     // Button placed in the background
var Automated GUILabel   BackButtonLabel;     // Back button label text
var Automated GUILabel   SelectButtonLabel;   // Select button label text
var Automated GUILabel   ErrorMessage;        // The error message to be displayed

var Automated GUIImage   BackButtonImage;     // The "B" button image
var Automated GUIImage   SelectButtonImage;   // The "A" button image

var sound ClickSound;

// Button strings for error boxes
var localized string cancel_string;                     // "Cancel"
var localized string back_string;                       // "Back"
var localized string accept_string;                     // "Accept"
var localized string decline_string;                    // "Decline"
var localized string continue_string;                   // "Continue"
var localized string dashboard_string;                  // "Dashboard"
var localized string new_account_string;                // "New Account"
var localized string troubleshooter_string;             // "Troubleshooter"
var localized string try_again_string;                  // "Try again"
var localized string update_string;                     // "Update"
var localized string create_match_string;               // "Create a new match"
var localized string recovery_string;                   // "Account Recovery"
var localized string read_now_string;                   // "Read now"
var localized string read_later_string;                 // "Read later"
var localized string join_string;                       // "Join later"
var localized string attach_voice;                      // "Attach Voice Message"
var localized string continue_no_save_string;           // "Continue without saving"
var localized string free_blocks_string;                // "Free more blocks"
var localized string switch_teams;                      // "Switch Teams"

var bool accept_input;
var float period;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);
    FixButtonLocations();
}

/*****************************************************************
 * Sets the caption displayed at the top of the page
 *****************************************************************
 */

function SetErrorCaption(string caption) {
    ErrorMessage.Caption = caption;
}

/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled) {
    Super.Closed(Sender,bCancelled);
    XDotzPlayerController(PlayerOwner()).bPauseRumble = false;
}

/*****************************************************************
 * Adds back and select buttons
 *****************************************************************
 */

function AddBackButton(string label) {
    BackButtonImage.SetVisibility(true);
    BackButtonLabel.SetVisibility(true);
    BackButtonLabel.Caption = label;
}

function AddSelectButton(string label) {
    SelectButtonImage.SetVisibility(true);
    SelectButtonLabel.SetVisibility(true);
    SelectButtonLabel.Caption = label;
}

function FixOneButton(GUIComponent c){
    c.WinWidth = c.WinWidth / WinWidth;
    c.WinHeight = c.WinHeight / WinHeight;
    c.WinLeft = c.WinLeft / WinWidth;
    c.WinTop = 1.0 - (1.0 - c.WinTop) / WinHeight;
}

function FixButtonLocations() {
    FixOneButton(BackButtonLabel);
    FixOneButton(SelectButtonLabel);
    FixOneButton(BackButtonImage);
    FixOneButton(SelectButtonImage);
}

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */
event Opened( GUIComponent Sender ) {
    accept_input = false;
    Log("Not Accepting input...");
    XDotzPlayerController(PlayerOwner()).bPauseRumble = true;
    class'UtilsXbox'.static.Stop_Rumble();
    SetTimer(0.1,false);
}



/*****************************************************************
 * Introduces a short pause before accepting keystrokes
 *****************************************************************
 */

function Timer ()
{
    if (accept_input == false ) {
        accept_input = true;
        SetTimer(period,true);
        Log("Accepting input...");
    } else {
        Periodic();
    }
}

function Periodic()
{
    super.Periodic();
}

/*****************************************************************
 * HandleKeyEven
 * Intercepts A and B presses
 *****************************************************************
 */

function bool HandleKeyEvent(out byte Key,out byte State,float delta) {

    // A short pause
    if (!accept_input) return false;

    // Key down only
    if (State != 1) return false;

    Log(" *** Button down " $ Key);

    if (Key == 200) {
       DoButtonA();
       return true;
    } else if (Key == 201 || Key==213) {
       DoButtonB();
       return true;
    } else if (Key == 202) {
       DoButtonX();
       return true;
    } else if (Key == 212) {
       DoButtonStart();
       return true;
    }

    return true;
}

function DoButtonA ()
{
   XDotzPlayerController(PlayerOwner()).bPauseRumble = false;
}

function DoButtonB ()
{
   XDotzPlayerController(PlayerOwner()).bPauseRumble = false;
}

function DoButtonX ()
{
   XDotzPlayerController(PlayerOwner()).bPauseRumble = false;
}

function DoButtonStart()
{
   XDotzPlayerController(PlayerOwner()).bPauseRumble = false;
}

/*****************************************************************
 * default properties
 *****************************************************************
 */

defaultproperties
{
     Begin Object Class=GUIButton Name=ErrorBackground_btn
         StyleName="BBHorizontalBarSolid"
         bBoundToParent=True
         bScaleToParent=True
         bAcceptsInput=False
         bNeverFocus=True
         WinHeight=1.000000
         RenderWeight=0.100000
         Name="ErrorBackground_btn"
     End Object
     ErrorBackground=GUIButton'DOTZMenu.XDOTZErrorPage.ErrorBackground_btn'
     Begin Object Class=GUILabel Name=BackButtonLabel_lbl
         Caption="Cancel"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         WinTop=0.890000
         WinLeft=0.080000
         WinWidth=0.400000
         WinHeight=0.100000
         RenderWeight=0.500000
         Name="BackButtonLabel_lbl"
     End Object
     BackButtonLabel=GUILabel'DOTZMenu.XDOTZErrorPage.BackButtonLabel_lbl'
     Begin Object Class=GUILabel Name=SelectButtonLabel_lbl
         Caption="OK"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         WinTop=0.890000
         WinLeft=0.450000
         WinWidth=0.400000
         WinHeight=0.100000
         RenderWeight=0.500000
         Name="SelectButtonLabel_lbl"
     End Object
     SelectButtonLabel=GUILabel'DOTZMenu.XDOTZErrorPage.SelectButtonLabel_lbl'
     Begin Object Class=GUILabel Name=ErrorMessage_lbl
         TextFont="XBigFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.100000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.800000
         RenderWeight=0.900000
         Name="ErrorMessage_lbl"
     End Object
     ErrorMessage=GUILabel'DOTZMenu.XDOTZErrorPage.ErrorMessage_lbl'
     Begin Object Class=GUIImage Name=BackButtonImage_icn
         Image=Texture'DOTZTInterface.Buttons.B'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         WinTop=0.890000
         WinLeft=0.030000
         WinWidth=0.070000
         WinHeight=0.070000
         RenderWeight=0.500000
         Name="BackButtonImage_icn"
     End Object
     BackButtonImage=GUIImage'DOTZMenu.XDOTZErrorPage.BackButtonImage_icn'
     Begin Object Class=GUIImage Name=SelectButtonImage_icn
         Image=Texture'DOTZTInterface.Buttons.A'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         WinTop=0.890000
         WinLeft=0.400000
         WinWidth=0.070000
         WinHeight=0.070000
         RenderWeight=0.500000
         Name="SelectButtonImage_icn"
     End Object
     SelectButtonImage=GUIImage'DOTZMenu.XDOTZErrorPage.SelectButtonImage_icn'
     ClickSound=Sound'DOTZXInterface.Select'
     cancel_string="Cancel"
     back_string="Back"
     accept_string="Accept"
     decline_string="Decline"
     continue_string="Continue"
     dashboard_string="Xbox Dashboard"
     new_account_string="Create New Account"
     troubleshooter_string="Troubleshooter"
     try_again_string="Try Again"
     update_string="Update"
     create_match_string="Create a new match"
     recovery_string="Account Recovery"
     read_now_string="Read Now"
     read_later_string="Read Later"
     join_string="Join"
     attach_voice="Attach Voice Message"
     continue_no_save_string="Continue Without Saving"
     free_blocks_string="Free More Blocks"
     switch_teams="Switch Teams"
     period=0.500000
     bRequire640x480=False
     bAllowedAsLast=True
     WinTop=0.250000
     WinLeft=0.100000
     WinWidth=0.800000
     WinHeight=0.500000
}
