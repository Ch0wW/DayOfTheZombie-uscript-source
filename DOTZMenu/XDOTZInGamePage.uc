// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//  XDOTZErrorPage - Base class for error pages
//-----------------------------------------------------------

class XDOTZInGamePage extends XDOTZPageBase;

var Automated GUILabel   PageCaption;
var automated GUIButton  InGameBackground;     // Button placed in the background

var Automated GUILabel   BackButtonLabel;
var Automated GUILabel   SelectButtonLabel;

var Automated GUIImage   BackButtonImage;
var Automated GUIImage   SelectButtonImage;

var localized string continue_string;                   // "Continue"
var localized string save_string;                   // "Continue"
var localized string appear_offline_string;             // "Appear Offline"
var localized string appear_online_string;              // "Appear Online"

var sound ClickSound;

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
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled) {
    Super.Closed(Sender,bCancelled);
    XDotzPlayerController(PlayerOwner()).bPauseRumble = false;
    Controller.MouseEmulation(false);
   log(self $ " Opened");
}


/*****************************************************************
 * Sets the caption displayed at the top of the page
 *****************************************************************
 */

function SetPageCaption(string caption) {
    PageCaption.Caption = caption;
}

/*****************************************************************
 * Adds back and accept buttons
 *****************************************************************
 */

function AddBackButton() {
    BackButtonImage.SetVisibility(true);
    BackButtonLabel.SetVisibility(true);
}

function AddSelectButton() {
    SelectButtonImage.SetVisibility(true);
    SelectButtonLabel.SetVisibility(true);
}

function AddContinueButton() {
    SelectButtonImage.SetVisibility(true);
    SelectButtonLabel.SetVisibility(true);
    SelectButtonLabel.Caption = continue_string;
}

function AddSaveButton() {
    SelectButtonImage.SetVisibility(true);
    SelectButtonLabel.SetVisibility(true);
    SelectButtonLabel.Caption = save_string;
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
    SetTimer(0.05,false);
    XDotzPlayerController(PlayerOwner()).bPauseRumble = true;
    class'UtilsXbox'.static.Stop_Rumble();

   log(self $ " Opened");
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

}

/*****************************************************************
 * HandleKeyEven
 * Intercepts A and B presses
 *****************************************************************
 */

function bool HandleKeyEvent(out byte Key,out byte State,float delta) {


   Log("HandleKeyEvent");
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
    }

   //for working with PC
    if (Key == 13){ //Enter
      DoButtonA();
    } else if (Key == 27){  //Esc
      DoButtonB();
    }

    return true;
}

/*****************************************************************
 *****************************************************************
 */

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

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     Begin Object Class=GUILabel Name=PageCaption_lbl
         TextFont="XBigFont"
         bMultiLine=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.120000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.100000
         Name="PageCaption_lbl"
     End Object
     PageCaption=GUILabel'DOTZMenu.XDOTZInGamePage.PageCaption_lbl'
     Begin Object Class=GUIButton Name=InGameBackground_btn
         StyleName="BBHorizontalBarSolid"
         bBoundToParent=True
         bScaleToParent=True
         bAcceptsInput=False
         bNeverFocus=True
         WinHeight=1.000000
         RenderWeight=0.100000
         Name="InGameBackground_btn"
     End Object
     InGameBackground=GUIButton'DOTZMenu.XDOTZInGamePage.InGameBackground_btn'
     Begin Object Class=GUILabel Name=BackButtonLabel_lbl
         Caption="Back"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.890000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         RenderWeight=0.500000
         Name="BackButtonLabel_lbl"
     End Object
     BackButtonLabel=GUILabel'DOTZMenu.XDOTZInGamePage.BackButtonLabel_lbl'
     Begin Object Class=GUILabel Name=SelectButtonLabel_lbl
         Caption="Select"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.890000
         WinLeft=0.350000
         WinWidth=0.400000
         WinHeight=0.100000
         RenderWeight=0.500000
         Name="SelectButtonLabel_lbl"
     End Object
     SelectButtonLabel=GUILabel'DOTZMenu.XDOTZInGamePage.SelectButtonLabel_lbl'
     Begin Object Class=GUIImage Name=BackButtonImage_icn
         Image=Texture'DOTZTInterface.Buttons.B'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.890000
         WinLeft=0.100000
         WinWidth=0.070000
         WinHeight=0.070000
         RenderWeight=0.500000
         Name="BackButtonImage_icn"
     End Object
     BackButtonImage=GUIImage'DOTZMenu.XDOTZInGamePage.BackButtonImage_icn'
     Begin Object Class=GUIImage Name=SelectButtonImage_icn
         Image=Texture'DOTZTInterface.Buttons.A'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.890000
         WinLeft=0.300000
         WinWidth=0.070000
         WinHeight=0.070000
         RenderWeight=0.500000
         Name="SelectButtonImage_icn"
     End Object
     SelectButtonImage=GUIImage'DOTZMenu.XDOTZInGamePage.SelectButtonImage_icn'
     continue_string="Continue"
     save_string="Save Settings"
     appear_offline_string="Appear Offline"
     appear_online_string="Appear Online"
     ClickSound=Sound'DOTZXInterface.Select'
     period=0.500000
     bRequire640x480=False
     bAllowedAsLast=True
     WinTop=0.100000
     WinLeft=0.100000
     WinWidth=0.800000
     WinHeight=0.850000
}
