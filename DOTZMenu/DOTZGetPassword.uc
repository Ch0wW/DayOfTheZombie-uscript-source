// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class DOTZGetPassword extends DOTZInGamePage;

var string  RetryURL;
var localized string PageCaption;

var automated GUIButton YesButton;
var automated GUIButton NoButton;
var Automated GUILabel  ErrorMessage;        // The error message to be displayed
var Automated BBEditBox PasswordBox;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner){
    Super.InitComponent(Mycontroller, MyOwner);
   SetPageCaption(PageCaption);
    PasswordBox.bConvertSpaces = true;
}

/*****************************************************************
 * HandleParameters
 *****************************************************************
 */
function HandleParameters(string URL,string Unused)
{
    RetryURL = URL;
}

/*****************************************************************
 * CancelClicked
 *****************************************************************
 */
function bool CancelClicked(GUIComponent Sender){
    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    Controller.OpenMenu("DOTZMenu.DOTZLoadingMenu");
    //PlayerOwner().ConsoleCommand("Disconnect");
    PlayerOwner().ConsoleCommand("start MainMenu.day");

    return true;
}

/*****************************************************************
 * LoadClicked
 *****************************************************************
 */
function bool LoadClicked(GUIComponent Sender){
    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
    PlayerOwner().ClientTravel(RetryURL$"?password="$PasswordBox.GetText(),TRAVEL_Absolute,false);
    Controller.OpenMenu("DOTZMenu.DOTZLoadingMenu");
    return true;
}

/*****************************************************************
 * HandleKeyEven
 * Intercepts A and B presses
 *****************************************************************
 */

function bool HandleKeyEvent(out byte Key,out byte State,float delta) {
    return true;
}

defaultproperties
{
     PageCaption="Password Required"
     Begin Object Class=GUIButton Name=cYesButton
         Caption="OK"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.800000
         WinLeft=0.600000
         WinWidth=0.250000
         WinHeight=0.100000
         __OnClick__Delegate=DOTZGetPassword.LoadClicked
         Name="cYesButton"
     End Object
     YesButton=GUIButton'DOTZMenu.DOTZGetPassword.cYesButton'
     Begin Object Class=GUIButton Name=cNoButton
         Caption="Quit"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.800000
         WinLeft=0.200000
         WinWidth=0.250000
         WinHeight=0.100000
         TabOrder=1
         __OnClick__Delegate=DOTZGetPassword.CancelClicked
         Name="cNoButton"
     End Object
     NoButton=GUIButton'DOTZMenu.DOTZGetPassword.cNoButton'
     Begin Object Class=GUILabel Name=ErrorMessage_lbl
         Caption="Enter password for the server:"
         TextFont="BigGuiFont"
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
     ErrorMessage=GUILabel'DOTZMenu.DOTZGetPassword.ErrorMessage_lbl'
     Begin Object Class=BBEditBox Name=GetPassPW
         WinTop=0.508594
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.060000
         Name="GetPassPW"
     End Object
     PasswordBox=BBEditBox'DOTZMenu.DOTZGetPassword.GetPassPW'
     WinTop=0.250000
     WinHeight=0.500000
     __OnKeyEvent__Delegate=DOTZGetPassword.HandleKeyEvent
}
