// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZMainMenu - the main menu for Xbox DOTZ, based on the Warfare
 *              "GUI" package.
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #2 $
 * @date    January 19, 2005
 */

class DOTZSPDead extends DOTZInGamePage;



//Page components
var Automated GuiButton  RevertToLastSaveButton;
var Automated GuiButton  QuitButton;

//configurable stuff
var string LoadMenu;      // System Link menu location

//configurable stuff
var localized string PageCaption;

var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);

    Log(self $ "InitComponent");
    SetPageCaption (PageCaption);
}


/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    Log(self $ "Opened");

    //don't exactly know what is going on here, but if you leave this
    //page and return to it, it seems to have nothing focused properly
    //so rather than understanding the problem, we 'fix' it by force as
    //is the game development way apparently.
    SetFocus(RevertToLastSaveButton);
    RevertToLastSaveButton.SetFocus(none);

    //MapControls();
//    RevertToLastSaveButton.MenuState = MSAT_Focused;

}

/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled) {
   Super.Closed(Sender,bCancelled);
    Log(self $ "Closed");
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

    PlayerOwner().PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case RevertToLastSaveButton:
            return Controller.OpenMenu(LoadMenu);
            break;

        case QuitButton:
            Controller.OpenMenu("DOTZMenu.DOTZLoadingMenu");
            PlayerOwner().Level.ServerTravel("MainMenu.day",false);
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
    Controller.CloseMenu(true);
}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     Begin Object Class=GUIButton Name=RevertToLastSaveButton_btn
         Caption="Load Game"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.200000
         WinLeft=0.325000
         WinWidth=0.350000
         WinHeight=0.099900
         TabOrder=2
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZSPDead.ButtonClicked
         Name="RevertToLastSaveButton_btn"
     End Object
     RevertToLastSaveButton=GUIButton'DOTZMenu.DOTZSPDead.RevertToLastSaveButton_btn'
     Begin Object Class=GUIButton Name=QuitButton_btn
         Caption="Quit"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.300000
         WinLeft=0.325000
         WinWidth=0.350000
         WinHeight=0.099900
         TabOrder=3
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZSPDead.ButtonClicked
         Name="QuitButton_btn"
     End Object
     QuitButton=GUIButton'DOTZMenu.DOTZSPDead.QuitButton_btn'
     LoadMenu="DOTZMenu.DOTZLoadMenuIG"
     PageCaption="You Died Loser"
     ClickSound=Sound'DOTZXInterface.Select'
     WinTop=0.250000
     WinLeft=0.250000
     WinWidth=0.500000
     WinHeight=0.500000
     __OnKeyEvent__Delegate=DOTZSPDead.HandleKeyEvent
}
