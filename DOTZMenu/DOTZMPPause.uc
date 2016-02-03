// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZMainMenu - the main menu for Xbox DOTZ, based on the Warfare
 *              "GUI" package.
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #3 $
 * @date    January 19, 2005
 */

class DOTZMPPause extends DOTZInGamePage;



//Page components
var Automated GuiButton  ContinueButton;
var Automated GuiButton  SwitchTeamsButton;
var Automated GuiButton  PlayersListButton;
var Automated GuiButton  OptionsButton;
var Automated GuiButton  QuitButton;
var Automated GuiButton  CycleMapButton;

//configurable stuff
var string ContinueMenu;              // Single Player menu location
var string PlayersListMenu;           // Xbox Live menu location
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
    local bool bTeamGame;

    Super.Initcomponent(MyController, MyOwner);

    SetPageCaption (PageCaption);

    bTeamGame = PlayerOwner().GameReplicationInfo.bTeamGame;

    //remove the switch teams option if not a team game
    if( (PlayerOwner() != none && PlayerOwner().GameReplicationInfo != none &&
        !PlayerOwner().GameReplicationInfo.bTeamGame) ||
        (PlayerOwner() != none && PlayerOwner().GameReplicationInfo != none &&
        !PlayerOwner().GameReplicationInfo.bAllowedToSwitchTeams)){

        PlayersListButton.WinTop = PlayersListButton.WinTop - 0.1;
        OptionsButton.WinTop = OptionsButton.WinTop - 0.1;
        QuitButton.WinTop = QuitButton.WinTop - 0.1;

        RemoveComponent(SwitchTeamsButton, true);

        MapControls();
    }

    if (PlayerOwner().Level.NetMode == NM_Client){
        RemoveComponent(CycleMapButton);
        MapControls();
    }
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
    AdvancedPlayerController(PlayerOwner()).UpdateActionKey();
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

        case SwitchTeamsButton:
             Controller.OpenMenu("DOTZMenu.DOTZSwitchTeamsConfirm");
             //DoButtonB ();
             return false;
             break;

        case PlayersListButton:
             return Controller.OpenMenu(PlayersListMenu);
             break;

        case OptionsButton:
             return Controller.OpenMenu(OptionsMenu);
             break;

        case CycleMapButton:
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
         __OnClick__Delegate=DOTZMPPause.ButtonClicked
         Name="ContinueButton_btn"
     End Object
     ContinueButton=GUIButton'DOTZMenu.DOTZMPPause.ContinueButton_btn'
     Begin Object Class=GUIButton Name=SwitchTeamsButton_btn
         Caption="Switch Teams"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.300000
         WinLeft=0.325000
         WinWidth=0.350000
         WinHeight=0.099900
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMPPause.ButtonClicked
         Name="SwitchTeamsButton_btn"
     End Object
     SwitchTeamsButton=GUIButton'DOTZMenu.DOTZMPPause.SwitchTeamsButton_btn'
     Begin Object Class=GUIButton Name=PlayersListButton_btn
         Caption="Scoreboard"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.325000
         WinWidth=0.350000
         WinHeight=0.099900
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMPPause.ButtonClicked
         Name="PlayersListButton_btn"
     End Object
     PlayersListButton=GUIButton'DOTZMenu.DOTZMPPause.PlayersListButton_btn'
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
         __OnClick__Delegate=DOTZMPPause.ButtonClicked
         Name="OptionsButton_btn"
     End Object
     OptionsButton=GUIButton'DOTZMenu.DOTZMPPause.OptionsButton_btn'
     Begin Object Class=GUIButton Name=QuitButton_btn
         Caption="Quit"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.325000
         WinWidth=0.350000
         WinHeight=0.099900
         TabOrder=3
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMPPause.ButtonClicked
         Name="QuitButton_btn"
     End Object
     QuitButton=GUIButton'DOTZMenu.DOTZMPPause.QuitButton_btn'
     Begin Object Class=GUIButton Name=CycleButton_btn
         Caption="Start Next Map"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.700000
         WinLeft=0.325000
         WinWidth=0.350000
         WinHeight=0.099900
         TabOrder=3
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMPPause.ButtonClicked
         Name="CycleButton_btn"
     End Object
     CycleMapButton=GUIButton'DOTZMenu.DOTZMPPause.CycleButton_btn'
     ContinueMenu="DOTZMenu.DOTZSPLevelList"
     PlayersListMenu="DOTZMenu.DOTZPlayersListIG"
     OptionsMenu="DOTZMenu.DOTZSettingsMenuIG"
     QuitMenu="DOTZMenu.DOTZMPQuitGameConfirm"
     PageCaption="Paused"
     ClickSound=Sound'DOTZXInterface.Select'
     WinTop=0.250000
     WinLeft=0.250000
     WinWidth=0.500000
     WinHeight=0.500000
     __OnKeyEvent__Delegate=DOTZMPPause.HandleKeyEvent
}
