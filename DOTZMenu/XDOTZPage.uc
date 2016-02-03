// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------

class XDOTZPage extends XDOTZPageBase;

var Automated GUILabel   PageCaption;
var Automated GUILabel   LiveCaption;

var Automated GUILabel   BackButtonLabel;
var Automated GUILabel   SelectButtonLabel;
var Automated GUILabel   ContinueButtonLabel;
var Automated GUILabel   NextButtonLabel;
var Automated GUILabel   SignUpButtonLabel;
var Automated GUILabel   NewProfileButtonLabel;
var Automated GUILabel   RefreshButtonLabel;
var Automated GUILabel   SaveButtonLabel;
var Automated GUILabel   BackspaceButtonLabel;

var Automated GUIImage   BackButtonImage;
var Automated GUIImage   SelectButtonImage;
var Automated GUIImage   XButtonImage;

//configurable stuff
var localized string LoggedIn;        // Single Player menu location
var localized string NeedPassword;    // Single Player menu location
var localized string FailedSignIn;
var localized string NotSignedIn;

var sound ClickSound;

var bool accept_input;
var float period;

/*****************************************************************
 * This gets called every 1/2 second
 *****************************************************************
 */

function Periodic ()
{
    super.Periodic();

    SetLoginName();
}

/*****************************************************************
 * Sets the caption displayed at the top of the page
 *****************************************************************
 */

function SetPageCaption(string caption) {
    PageCaption.Caption = caption;
}

function SetLoginName()
{

    // Done in player controller
    /*if (class'UtilsXbox'.static.Get_Captured_Controller() >= 0
        && !class'UtilsXbox'.static.Check_Captured_Controller()) {
        // Open unplugged controller menu
        Controller.OpenMenu("DOTZMenu.XDOTZNoController");
    } */



    if (class'UtilsXbox'.static.Network_Is_Unplugged()) {
        // CARROT: Sign out done in error box
        //class'UtilsXbox'.static.Sign_Out();
        LiveCaption.Caption = FailedSignIn;
        return;
    }

    if (class'UtilsXbox'.static.Is_Signed_In())
        LiveCaption.Caption = LoggedIn $ " " $ class'UtilsXbox'.static.Get_Current_Name();
    else if (class'UtilsXbox'.static.Is_Auto_Need_Password())
        LiveCaption.Caption = NeedPassword;
    else if (class'UtilsXbox'.static.Is_Auto_Failed())
        LiveCaption.Caption = FailedSignIn;
    else
        LiveCaption.Caption = NotSignedIn;

   //LoggedIn;
   //NeedPassword;
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
    ContinueButtonLabel.SetVisibility(true);
}

function AddNextButton() {
    XButtonImage.SetVisibility(true);
    NextButtonLabel.SetVisibility(true);
}

function AddRefreshButton() {
    XButtonImage.SetVisibility(true);
    RefreshButtonLabel.SetVisibility(true);
}

function AddSignUpButton() {
    XButtonImage.SetVisibility(true);
    SignUpButtonLabel.SetVisibility(true);
}

function AddNewProfileButton() {
    XButtonImage.SetVisibility(true);
    NewProfileButtonLabel.SetVisibility(true);
}

function AddSaveButton() {
    SelectButtonImage.SetVisibility(true);
    SaveButtonLabel.SetVisibility(true);
}

function AddBackspaceButton() {
    XButtonImage.SetVisibility(true);
    BackspaceButtonLabel.SetVisibility(true);
}

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */
event Opened( GUIComponent Sender ) {
    accept_input = false;
    Log("Not Accepting input...");
    SetTimer(0.05,false);

    SetLoginName();
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


/*****************************************************************
 * HandleKeyEven
 * It was like this when I got here
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

    //for working with PC
    if (Key == 13){ //Enter
      DoButtonA();
    } else if (Key == 27){  //Esc
      DoButtonB();
    } else if  (Key == 32){
      DoButtonStart();
    }


    return true;
}

function DoButtonA ()
{

}

function DoButtonB ()
{

}

function DoButtonX ()
{

}

function DoButtonStart ()
{
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
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.123000
         WinLeft=0.155000
         WinWidth=0.800000
         WinHeight=0.100000
         Name="PageCaption_lbl"
     End Object
     PageCaption=GUILabel'DOTZMenu.XDOTZPage.PageCaption_lbl'
     Begin Object Class=GUILabel Name=LiveCaption_lbl
         TextAlign=TXTA_Right
         TextFont="XPlainSmFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.085000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.010000
         Name="LiveCaption_lbl"
     End Object
     LiveCaption=GUILabel'DOTZMenu.XDOTZPage.LiveCaption_lbl'
     Begin Object Class=GUILabel Name=BackButtonLabel_lbl
         Caption="Back"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.850000
         WinLeft=0.205000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="BackButtonLabel_lbl"
     End Object
     BackButtonLabel=GUILabel'DOTZMenu.XDOTZPage.BackButtonLabel_lbl'
     Begin Object Class=GUILabel Name=SelectButtonLabel_lbl
         Caption="Select"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.850000
         WinLeft=0.405000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="SelectButtonLabel_lbl"
     End Object
     SelectButtonLabel=GUILabel'DOTZMenu.XDOTZPage.SelectButtonLabel_lbl'
     Begin Object Class=GUILabel Name=ContinueButtonLabel_lbl
         Caption="Continue"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.850000
         WinLeft=0.405000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="ContinueButtonLabel_lbl"
     End Object
     ContinueButtonLabel=GUILabel'DOTZMenu.XDOTZPage.ContinueButtonLabel_lbl'
     Begin Object Class=GUILabel Name=NextButtonLabel_lbl
         Caption="Next"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.850000
         WinLeft=0.605000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="NextButtonLabel_lbl"
     End Object
     NextButtonLabel=GUILabel'DOTZMenu.XDOTZPage.NextButtonLabel_lbl'
     Begin Object Class=GUILabel Name=SignUpButtonLabel_lbl
         Caption="Create New Account"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.850000
         WinLeft=0.605000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="SignUpButtonLabel_lbl"
     End Object
     SignUpButtonLabel=GUILabel'DOTZMenu.XDOTZPage.SignUpButtonLabel_lbl'
     Begin Object Class=GUILabel Name=NewProfileButtonLabel_lbl
         Caption="New Profile"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.850000
         WinLeft=0.605000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="NewProfileButtonLabel_lbl"
     End Object
     NewProfileButtonLabel=GUILabel'DOTZMenu.XDOTZPage.NewProfileButtonLabel_lbl'
     Begin Object Class=GUILabel Name=RefreshButtonLabel_lbl
         Caption="Refresh"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.850000
         WinLeft=0.605000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="RefreshButtonLabel_lbl"
     End Object
     RefreshButtonLabel=GUILabel'DOTZMenu.XDOTZPage.RefreshButtonLabel_lbl'
     Begin Object Class=GUILabel Name=SaveButtonLabel_lbl
         Caption="Save Settings"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.850000
         WinLeft=0.405000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="SaveButtonLabel_lbl"
     End Object
     SaveButtonLabel=GUILabel'DOTZMenu.XDOTZPage.SaveButtonLabel_lbl'
     Begin Object Class=GUILabel Name=BackspaceButtonLabel_lbl
         Caption="Backspace"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.850000
         WinLeft=0.605000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="BackspaceButtonLabel_lbl"
     End Object
     BackspaceButtonLabel=GUILabel'DOTZMenu.XDOTZPage.BackspaceButtonLabel_lbl'
     Begin Object Class=GUIImage Name=BackButtonImage_icn
         Image=Texture'DOTZTInterface.Buttons.B'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.850000
         WinLeft=0.155000
         WinWidth=0.070000
         WinHeight=0.070000
         Name="BackButtonImage_icn"
     End Object
     BackButtonImage=GUIImage'DOTZMenu.XDOTZPage.BackButtonImage_icn'
     Begin Object Class=GUIImage Name=SelectButtonImage_icn
         Image=Texture'DOTZTInterface.Buttons.A'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.850000
         WinLeft=0.355000
         WinWidth=0.070000
         WinHeight=0.070000
         Name="SelectButtonImage_icn"
     End Object
     SelectButtonImage=GUIImage'DOTZMenu.XDOTZPage.SelectButtonImage_icn'
     Begin Object Class=GUIImage Name=XButtonImage_icn
         Image=Texture'DOTZTInterface.Buttons.X'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.850000
         WinLeft=0.555000
         WinWidth=0.070000
         WinHeight=0.070000
         Name="XButtonImage_icn"
     End Object
     XButtonImage=GUIImage'DOTZMenu.XDOTZPage.XButtonImage_icn'
     LoggedIn="Signed-In:"
     NeedPassword="Not Signed-In: Pass code Needed"
     FailedSignIn="Sign-In Failed"
     NotSignedIn="Not Signed-In"
     ClickSound=Sound'DOTZXInterface.Select'
     period=0.100000
     bRequire640x480=False
     bAllowedAsLast=True
     WinHeight=1.000000
}
