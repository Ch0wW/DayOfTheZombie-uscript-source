// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZMainMenu - the main menu for Xbox DOTZ, based on the Warfare
 *              "GUI" package.
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class DOTZSPPause extends DOTZInGamePage;



//Page components
var Automated GuiButton  ContinueButton;
var Automated GuiButton  LoadButton;
var Automated GuiButton  SaveButton;
var Automated GuiButton  OptionsButton;
var Automated GuiButton  QuitButton;

//configurable stuff
var string ContinueMenu;              // Single Player menu location
var string LoadMenu;
var string SaveMenu;
var string OptionsMenu;      // System Link menu location
var string QuitMenu;                  // Profile menu location

//configurable stuff
var localized string PageCaption;

var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);

    SetPageCaption (PageCaption);
}


/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

     // Add a delay before accepting input
    accept_input = false;
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
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */
function bool ButtonClicked(GUIComponent Sender) {
    local GUIButton Selected;

    if (GUIButton(Sender) != None) Selected = GUIButton(Sender);
    if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case ContinueButton:
             Controller.ViewportOwner.Actor.SetPause(false);
             return Controller.CloseMenu(true);
             break;

        case LoadButton:
             return Controller.OpenMenu(LoadMenu);
             break;

        case SaveButton:
             return Controller.OpenMenu(SaveMenu);
             break;

        //case LoadButton:
             //return Controller.OpenMenu(LoadMenu,"true");
             //break;

        case OptionsButton:
             return Controller.OpenMenu(OptionsMenu);
             break;

        case QuitButton:
             return Controller.OpenMenu(QuitMenu);
             break;
    };

    return false;
}

/*****************************************************************
 * NotifyLevelChange
 *
 *****************************************************************
 */
event NotifyLevelChange() {
    //Controller.CloseMenu(true);
}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     Begin Object Class=GUIButton Name=ContinueButton_btn
         Caption="Continue"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.200000
         WinLeft=0.325000
         WinWidth=0.350000
         WinHeight=0.099900
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZSPPause.ButtonClicked
         Name="ContinueButton_btn"
     End Object
     ContinueButton=GUIButton'DOTZMenu.DOTZSPPause.ContinueButton_btn'
     Begin Object Class=GUIButton Name=LoadButton_btn
         Caption="Load Game"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.300000
         WinLeft=0.325000
         WinWidth=0.350000
         WinHeight=0.099900
         TabOrder=2
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZSPPause.ButtonClicked
         Name="LoadButton_btn"
     End Object
     LoadButton=GUIButton'DOTZMenu.DOTZSPPause.LoadButton_btn'
     Begin Object Class=GUIButton Name=SaveButton_btn
         Caption="Save Game"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.325000
         WinWidth=0.350000
         WinHeight=0.099900
         TabOrder=2
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZSPPause.ButtonClicked
         Name="SaveButton_btn"
     End Object
     SaveButton=GUIButton'DOTZMenu.DOTZSPPause.SaveButton_btn'
     Begin Object Class=GUIButton Name=OptionsButton_btn
         Caption="Settings"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.325000
         WinWidth=0.350000
         WinHeight=0.099900
         TabOrder=3
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZSPPause.ButtonClicked
         Name="OptionsButton_btn"
     End Object
     OptionsButton=GUIButton'DOTZMenu.DOTZSPPause.OptionsButton_btn'
     Begin Object Class=GUIButton Name=QuitButton_btn
         Caption="Quit"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.325000
         WinWidth=0.350000
         WinHeight=0.099900
         TabOrder=4
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZSPPause.ButtonClicked
         Name="QuitButton_btn"
     End Object
     QuitButton=GUIButton'DOTZMenu.DOTZSPPause.QuitButton_btn'
     ContinueMenu="DOTZMenu.DOTZSPLevelList"
     LoadMenu="DOTZMenu.DOTZLoadMenuIG"
     SaveMenu="DOTZMenu.DOTZSaveMenu"
     OptionsMenu="DOTZMenu.DOTZSettingsMenuIG"
     QuitMenu="DOTZMenu.DOTZQuitGameConfirm"
     PageCaption="Paused"
     ClickSound=Sound'DOTZXInterface.Select'
     period=0.100000
     WinTop=0.250000
     WinLeft=0.250000
     WinWidth=0.500000
     WinHeight=0.500000
     __OnKeyEvent__Delegate=DOTZSPPause.HandleKeyEvent
}
