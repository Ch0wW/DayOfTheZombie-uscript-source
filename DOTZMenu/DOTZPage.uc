// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------

class DOTZPage extends DOTZPageBase;

var Automated GUILabel   PageCaption;

var Automated GUIButton   BackButtonLabel;
var Automated GUIButton   NextButtonLabel;

var sound ClickSound;


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
    //BackButtonImage.SetVisibility(true);
    BackButtonLabel.bVisible = true;
    BackButtonLabel.bNeverFocus = false;
    MapControls();
}

function AddNextButton() {
    //NextButtonImage.SetVisibility(true);
    NextButtonLabel.bVisible = true;
    NextButtonLabel.bNeverFocus = false;
    MapControls();
}

/*****************************************************************
 *****************************************************************
 */

function Click_Back ()
{
    Controller.CloseMenu(true);
    Log("Click Back");
}


function Click_Next ()
{
    Log("Click Next");
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
    //Log(" *** Button down " $ Key);

    if (Key == 27) {  //Esc
        // Unpause if this is the last menu
        if (BBGUIController(Controller).GetMenuStackSize() != 1) {
            Controller.CloseMenu(true);
        }


    }

    return true;
}

/*****************************************************************
 * ButtonClicked
 *****************************************************************
 */

function bool ButtonClickedBase( GUIComponent Sender ) {
    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    if (Sender == BackButtonLabel)
        Click_Back();
    else if (Sender == NextButtonLabel)
        Click_Next();

    return true;
}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     Begin Object Class=GUILabel Name=PageCaption_lbl
         TextFont="BigGuiFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.065000
         WinLeft=0.070000
         WinWidth=0.800000
         WinHeight=0.100000
         Name="PageCaption_lbl"
     End Object
     PageCaption=GUILabel'DOTZMenu.DOTZPage.PageCaption_lbl'
     Begin Object Class=GUIButton Name=BackButtonLabel_lbl
         Caption="Back"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.910000
         WinLeft=0.100000
         WinWidth=0.200000
         WinHeight=0.050000
         __OnClick__Delegate=DOTZPage.ButtonClickedBase
         Name="BackButtonLabel_lbl"
     End Object
     BackButtonLabel=GUIButton'DOTZMenu.DOTZPage.BackButtonLabel_lbl'
     Begin Object Class=GUIButton Name=NextButtonLabel_lbl
         Caption="Next"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.910000
         WinLeft=0.700000
         WinWidth=0.200000
         WinHeight=0.050000
         __OnClick__Delegate=DOTZPage.ButtonClickedBase
         Name="NextButtonLabel_lbl"
     End Object
     NextButtonLabel=GUIButton'DOTZMenu.DOTZPage.NextButtonLabel_lbl'
     ClickSound=Sound'DOTZXInterface.Select'
     bRequire640x480=False
     bAllowedAsLast=True
     WinHeight=1.000000
}
