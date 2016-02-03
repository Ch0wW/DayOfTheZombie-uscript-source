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

class DOTZMPDead extends DOTZInGamePage;



//Page components
var Automated GuiButton  PlayersListButton;
var Automated GuiButton  CycleButton;
var Automated GuiButton  QuitButton;

//configurable stuff
var string PlayersListMenu;           // Xbox Live menu location
var string ScoreboardListMenu;           // Xbox Live menu location
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

    if( PlayerOwner().Level.Game == None){

        QuitButton.WinTop = QuitButton.WinTop - 0.1;

        RemoveComponent(CycleButton, true);
        MapControls();
    }

    Controller.OpenMenu(ScoreboardListMenu);
}


/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);
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
        case PlayersListButton:
             return Controller.OpenMenu(PlayersListMenu);
             break;

        case CycleButton:
             PlayerOwner().Level.Game.RestartGame();
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
    Controller.CloseMenu(true);
}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     Begin Object Class=GUIButton Name=PlayersListButton_btn
         Caption="Scoreboard"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.200000
         WinLeft=0.325000
         WinWidth=0.350000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMPDead.ButtonClicked
         Name="PlayersListButton_btn"
     End Object
     PlayersListButton=GUIButton'DOTZMenu.DOTZMPDead.PlayersListButton_btn'
     Begin Object Class=GUIButton Name=CycleButton_btn
         Caption="Start Next Map"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.300000
         WinLeft=0.325000
         WinWidth=0.350000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMPDead.ButtonClicked
         Name="CycleButton_btn"
     End Object
     CycleButton=GUIButton'DOTZMenu.DOTZMPDead.CycleButton_btn'
     Begin Object Class=GUIButton Name=QuitButton_btn
         Caption="Quit"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.325000
         WinWidth=0.350000
         WinHeight=0.080000
         TabOrder=3
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMPDead.ButtonClicked
         Name="QuitButton_btn"
     End Object
     QuitButton=GUIButton'DOTZMenu.DOTZMPDead.QuitButton_btn'
     PlayersListMenu="DOTZMenu.DOTZPlayersListIG"
     ScoreboardListMenu="DOTZMenu.DOTZScoreboardIG"
     QuitMenu="DOTZMenu.DOTZMPQuitGameConfirm"
     PageCaption="You Died"
     ClickSound=Sound'DOTZXInterface.Select'
     WinTop=0.250000
     WinLeft=0.250000
     WinWidth=0.500000
     WinHeight=0.500000
     __OnKeyEvent__Delegate=DOTZMPDead.HandleKeyEvent
}
