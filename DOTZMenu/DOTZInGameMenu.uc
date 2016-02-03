// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZMainMenu - the main menu for Desert Thunder, based on the Warfare
 *              "GUI" package.
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #2 $
 * @date    Sept 2003
 */
class DOTZInGameMenu extends DOTZSinglePlayerBase;



//controls
var Automated GuiButton NewGameButton;
var Automated GuiButton ResumeGameButton;
var Automated GuiButton LoadGameButton;
var Automated GuiButton SaveGameButton;
var Automated GuiButton SettingsButton;
var Automated GuiButton StoryButton;
var Automated GuiButton  CreditButton;
var Automated GuiButton QuitButton;
var Automated GuiButton BonusButton;

//configurable stuff
var string NewGameLevel;     //the level to load when they press new game
var string SaveMenu;         //the location of the save menu
var string LoadMenu;         //the location of the load menu
var string SettingsMenu;     //the location of the settings menu
var string StoryMenu;        //the location of the settings menu
var string QuitConfirm;      //dialog to display when quitting
var string CreditMenu;

//internal
//var int escHack;
var string StoryType;
var sound ClickSound;


/*****************************************************************
 * InitComponent
 *****************************************************************
 */
function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
   Super.Initcomponent(MyController, MyOwner);
}

/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    local AdvancedGameInfo g;
    local int lChapterMax, lPageMax;

    super.Opened( sender );
    g = AdvancedGameInfo( PlayerOwner().Level.Game );
    if ( g != none ) {
        if (g.bDisableSave) SaveGameButton.MenuState = MSAT_Disabled;
        else SaveGameButton.MenuState = MSAT_Blurry;
    }

   lChapterMax = class'DOTZGameInfoBase'.static.GetBestChapter();
   lPageMax = class'DOTZGameInfoBase'.static.GetBestPage();

   BonusButton.bVisible = false;
   if (lChapterMax >= 11 && (lPageMax >= 8  || lPageMax == -1)){
    BonusButton.bVisible = true;
   }



}

/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled) {
   //escHack = 0;
   Super.Closed(Sender,bCancelled);
   Controller.MouseEmulation(false);
}


/*****************************************************************
 * ButtonCllicked
 *****************************************************************
 */
function bool ButtonClicked(GUIComponent Sender) {
   local GUIButton Selected;

   if (GUIButton(Sender) != None) Selected = GUIButton(Sender);
   if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

      switch (Selected) {

      //NEW GAME BUTTON
        case NewGameButton:
           Console(Controller.Master.Console).ConsoleCommand( NewGameLevel );
           Controller.CloseAll(false);
           return true;

      //RESUME GAME BUTTON
      case ResumeGameButton:
         Controller.ViewportOwner.Actor.Level.Game
            .SetPause( false, Controller.ViewportOwner.Actor );
         Controller.CloseAll( false );
          return true;

      //LOAD GAME BUTTON
      case LoadGameButton:
         //escHack = 0; //may not come back from load menu to close this one.
           return Controller.OpenMenu(LoadMenu);

      //SAVE GAME BUTTON
      case SaveGameButton:
           return Controller.OpenMenu(SaveMenu);

      //SETTINGS BUTTON
      case SettingsButton:
           return Controller.OpenMenu(SettingsMenu);

      //REVIEW STORY
      case StoryButton:
           return Controller.OpenMenu(StoryMenu, "local");

      //CREDITS
      case CreditButton:
           return Controller.OpenMenu(CreditMenu);

      //QUIT BUTTON
      case QuitButton:
            return Controller.OpenMenu(QuitConfirm);

     case BonusButton:
        Console(Controller.Master.Console).ConsoleCommand( "start ZombieArena" );
        Controller.CloseMenu(false);
        return true;


   }
   return false;
}


/*****************************************************************
 * HandleKeyEvent
 *****************************************************************
 */
/*function bool HandleKeyEvent(out byte Key,out byte State,float delta) {

   if (Key==0x1B) { //esc
      escHack += 1;
      if (escHack ==2){
         //           escHack = 0;
         Controller.ViewportOwner.Actor.Level.Game
            .SetPause( false, Controller.ViewportOwner.Actor );
           Controller.CloseAll(false);
      }
   }
   //@@@ need to do something about the button-skipping problem here?
   return true;
}*/


/*****************************************************************
 * NotifyLevelChange
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
     Begin Object Class=GUIButton Name=NewGameButton_btn
         Caption="New Game"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Play Marine Heavy Gunner!"
         WinTop=0.450000
         WinLeft=0.400000
         WinWidth=0.350000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZInGameMenu.ButtonClicked
         Name="NewGameButton_btn"
     End Object
     NewGameButton=GUIButton'DOTZMenu.DOTZInGameMenu.NewGameButton_btn'
     Begin Object Class=GUIButton Name=ResumeGameButton_btn
         Caption="Resume"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Play Marine Heavy Gunner!"
         WinTop=0.500000
         WinLeft=0.400000
         WinWidth=0.350000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZInGameMenu.ButtonClicked
         Name="ResumeGameButton_btn"
     End Object
     ResumeGameButton=GUIButton'DOTZMenu.DOTZInGameMenu.ResumeGameButton_btn'
     Begin Object Class=GUIButton Name=LoadGameButton_btn
         Caption="Load Game"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Play Marine Heavy Gunner!"
         WinTop=0.550000
         WinLeft=0.400000
         WinWidth=0.350000
         WinHeight=0.080000
         TabOrder=2
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZInGameMenu.ButtonClicked
         Name="LoadGameButton_btn"
     End Object
     LoadGameButton=GUIButton'DOTZMenu.DOTZInGameMenu.LoadGameButton_btn'
     Begin Object Class=GUIButton Name=SaveGameButton_btn
         Caption="Save Game"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Save your progress"
         WinTop=0.600000
         WinLeft=0.400000
         WinWidth=0.350000
         WinHeight=0.080000
         TabOrder=3
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZInGameMenu.ButtonClicked
         Name="SaveGameButton_btn"
     End Object
     SaveGameButton=GUIButton'DOTZMenu.DOTZInGameMenu.SaveGameButton_btn'
     Begin Object Class=GUIButton Name=settingsButton_btn
         Caption="Settings"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Change settings"
         WinTop=0.650000
         WinLeft=0.400000
         WinWidth=0.350000
         WinHeight=0.080000
         TabOrder=4
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZInGameMenu.ButtonClicked
         Name="settingsButton_btn"
     End Object
     SettingsButton=GUIButton'DOTZMenu.DOTZInGameMenu.settingsButton_btn'
     Begin Object Class=GUIButton Name=StoryButton_btn
         Caption="The Story So Far..."
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Exit the game"
         WinTop=0.700000
         WinLeft=0.400000
         WinWidth=0.350000
         WinHeight=0.080000
         TabOrder=5
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZInGameMenu.ButtonClicked
         Name="StoryButton_btn"
     End Object
     StoryButton=GUIButton'DOTZMenu.DOTZInGameMenu.StoryButton_btn'
     Begin Object Class=GUIButton Name=CreditButton_btn
         Caption="Credits"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Credits"
         WinTop=0.750000
         WinLeft=0.400000
         WinWidth=0.350000
         WinHeight=0.080000
         TabOrder=4
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZInGameMenu.ButtonClicked
         Name="CreditButton_btn"
     End Object
     CreditButton=GUIButton'DOTZMenu.DOTZInGameMenu.CreditButton_btn'
     Begin Object Class=GUIButton Name=QuitButton_btn
         Name="QuitButton_btn"
     End Object
     QuitButton=GUIButton'DOTZMenu.DOTZInGameMenu.QuitButton_btn'
     Begin Object Class=GUIButton Name=BonusButton_btn
         Caption="Bonus"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.850000
         WinLeft=0.400000
         WinWidth=0.350000
         WinHeight=0.080000
         TabOrder=6
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZInGameMenu.ButtonClicked
         Name="BonusButton_btn"
     End Object
     BonusButton=GUIButton'DOTZMenu.DOTZInGameMenu.BonusButton_btn'
     NewGameLevel="start Level-01"
     SaveMenu="DOTZMenu.DOTZSaveMenu"
     LoadMenu="DOTZMenu.DOTZLoadMenu"
     SettingsMenu="DOTZMenu.DOTZSettingsMenu"
     StoryMenu="DOTZMenu.DOTZStoryMenu"
     QuitConfirm="DOTZMenu.DOTZQuitConfirm"
     CreditMenu="DOTZMenu.DOTZCreditsMenu"
     StoryType="local"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.MainMenuBackGround'
     bPersistent=True
     __OnKeyEvent__Delegate=DOTZInGameMenu.HandleKeyEvent
}
