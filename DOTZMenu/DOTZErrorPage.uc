// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//  XDOTZErrorPage - Base class for error pages
//-----------------------------------------------------------

class DOTZErrorPage extends DOTZPageBase;

var automated GUIButton  ErrorBackground;     // Button placed in the background
var Automated GUILabel   BackButtonLabel;     // Back button label text
var Automated GUILabel   SelectButtonLabel;   // Select button label text
var Automated GUILabel   ErrorMessage;        // The error message to be displayed

var Automated GUIImage   BackButtonImage;     // The "B" button image
var Automated GUIImage   SelectButtonImage;   // The "A" button image

var sound ClickSound;

// Button strings for error boxes
var localized string cancel_string;                     // "Cancel"
var localized string accept_string;                     // "Accept"
var localized string continue_string;                   // "Continue"
var localized string switch_teams;                      // "Switch Teams"

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
 * HandleKeyEven
 * Intercepts A and B presses
 *****************************************************************
 */

function bool HandleKeyEvent(out byte Key,out byte State,float delta) {

    // A short pause
    if (!accept_input) return false;

    // Key down only
    if (State != 1) return false;

    if (Key == 27) {  //Esc
        Controller.CloseMenu(true);
    }


    return true;
}

/*****************************************************************
 * Default properties
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
     ErrorBackground=GUIButton'DOTZMenu.DOTZErrorPage.ErrorBackground_btn'
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
     BackButtonLabel=GUILabel'DOTZMenu.DOTZErrorPage.BackButtonLabel_lbl'
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
     SelectButtonLabel=GUILabel'DOTZMenu.DOTZErrorPage.SelectButtonLabel_lbl'
     Begin Object Class=GUILabel Name=ErrorMessage_lbl
         TextFont="PlainGuiFont"
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
     ErrorMessage=GUILabel'DOTZMenu.DOTZErrorPage.ErrorMessage_lbl'
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
     BackButtonImage=GUIImage'DOTZMenu.DOTZErrorPage.BackButtonImage_icn'
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
     SelectButtonImage=GUIImage'DOTZMenu.DOTZErrorPage.SelectButtonImage_icn'
     ClickSound=Sound'DOTZXInterface.Select'
     cancel_string="Cancel"
     accept_string="Accept"
     continue_string="Continue"
     switch_teams="Switch Teams"
     bRequire640x480=False
     bAllowedAsLast=True
     WinTop=0.250000
     WinLeft=0.100000
     WinWidth=0.800000
     WinHeight=0.500000
}
