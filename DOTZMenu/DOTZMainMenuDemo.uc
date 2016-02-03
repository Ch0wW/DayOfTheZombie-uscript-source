// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZMainMenu - the main menu for DOTZ, based on the Warfare
 *              "GUI" package.
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #2 $
 * @date    Sept 2003
 */
class DOTZMainMenuDemo extends DOTZDemo
    implements( VideoNotification );



//Page components
var Automated GuiButton  SinglePlayerButton;
var Automated GuiButton  JoinButton;
var Automated GuiButton  HostButton;
var Automated GuiButton  ProfilesButton;
var Automated GuiButton  SettingsButton;
var Automated GuiButton  MovieTrailerButton;
var Automated GuiButton  QuitButton;

//configurable stuff
var string SinglePlayerMenu;
var string JoinMenu;
var string HostMenu;
var string ProfilesMenu;
var string SettingsMenu;
var string QuitMenu;

var sound ClickSound;
var string LevelNameTxt;


var VideoPlayer testVideo;
var bool bVideoIsPlaying;
var bool musicCancelled;





 /*****************************************************************
  * InitComponent
  *****************************************************************
  */
function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
   Super.Initcomponent(MyController, MyOwner);
   // init my components...

   JoinButton.MenuState = MSAT_Disabled;
   HostButton.MenuState = MSAT_Disabled;
   ProfilesButton.MenuState = MSAT_Disabled;
   testVideo = new(self) class'BinkVideoPlayer';
   testVideo.RegisterForNotification(self); //let me know when a video ends

}


/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    super.Opened( Sender );
}

/*****************************************************************
 * HandleParameters
 * When open menu get's called, the parameter values are supplied
 * here.
 *
 * Param1 - the menu to load
 * Param2 - the name of the sub menu to load on top of the first menu
 *****************************************************************
 */
event HandleParameters( String param1, String param2 ) {

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

  // if movie is playing, stop movie
    if(testVideo.VideoIsPlaying())
    {
        testVideo.StopVideo();
        accept_input = false;
        return true;
    }


    switch (Selected)
    {

        //SINGLEPLAYER GAME BUTTON
        case SinglePlayerButton:
            Controller.OpenMenu(SinglePlayerMenu);
               // Display loading screen
             Controller.OpenMenu("DOTZMenu.DOTZLoadingMenu",LevelNameTxt);
             PlayerOwner().Level.ServerTravel("CH10.dz",false);
            //Console(Controller.Master.Console).ConsoleCommand( NewGameLevel );
            //Controller.CloseMenu(false);
            //Controller.OpenMenu("DOTZMenu.DOTZLoadingMenu",,"DOTZTStory.Chapter1.1Page1"); //,"DOTZTStory.Chapter11.11Load");
            return true;

        //JOIN GAME BUTTON
        case JoinButton:
            return true; //Controller.OpenMenu(JoinMenu); break;

        //HOST BUTTON
        case HostButton:
            return true; // Controller.OpenMenu(HostMenu); break;

        //PROFILES BUTTON
        case ProfilesButton:
            return true; // Controller.OpenMenu(ProfilesMenu); break;

        //SETTINGS BUTTON
        case SettingsButton:
            return Controller.OpenMenu(SettingsMenu); break;

        case MovieTrailerButton:
            if (!bVideoIsPlaying){
                bVideoIsPlaying = true;
                testVideo.PlayVideo("MovieTrailer.bik");

                PlayerOwner().StopAllMusic(0.1);
                musicCancelled = true;

            } else {
                testVideo.StopVideo();
                return true;
            }
            break;

        //QUIT BUTTON
        case QuitButton:
            return Controller.OpenMenu(QuitMenu); break;
    }
   return false;
}


function VideoComplete(bool completed){
   bVideoIsPlaying = false;
}

/*****************************************************************
 * HandleKeyEven
 * It was like this when I got here
 *****************************************************************
 */
function bool HandleKeyEvent(out byte Key,out byte State,float delta) {

   return true;
}

/*****************************************************************
 * This gets called every 1/2 second
 *****************************************************************
 */

function Periodic ()
{
    super.Periodic();

    // Fire off the video after a while
    if (!testVideo.VideoIsPlaying()) {

        // Restart music if it was cancelled
        if (musicCancelled) {
            PlayerOwner().PlayMusic(PlayerOwner().Level.Song,0.1);
            musicCancelled = false;
        }

    }
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
// defaultproperties
//===========================================================================

defaultproperties
{
     Begin Object Class=GUIButton Name=SinglePlayerButton_btn
         Caption="Play Demo"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Play Day of the Zombie Single Player!"
         WinTop=0.500000
         WinLeft=0.325000
         WinWidth=0.350000
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMainMenuDemo.ButtonClicked
         Name="SinglePlayerButton_btn"
     End Object
     SinglePlayerButton=GUIButton'DOTZMenu.DOTZMainMenuDemo.SinglePlayerButton_btn'
     Begin Object Class=GUIButton Name=JoinGameButton_btn
         Caption="Play Online / LAN Game"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Join a Day of the Zombie Multiplayer match."
         WinTop=0.550000
         WinLeft=0.325000
         WinWidth=0.350000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMainMenuDemo.ButtonClicked
         Name="JoinGameButton_btn"
     End Object
     JoinButton=GUIButton'DOTZMenu.DOTZMainMenuDemo.JoinGameButton_btn'
     Begin Object Class=GUIButton Name=HostGameButton_btn
         Caption="Host Multiplayer Game"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Set up a Day of the Zombie Multiplayer match."
         WinTop=0.600000
         WinLeft=0.325000
         WinWidth=0.350000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMainMenuDemo.ButtonClicked
         Name="HostGameButton_btn"
     End Object
     HostButton=GUIButton'DOTZMenu.DOTZMainMenuDemo.HostGameButton_btn'
     Begin Object Class=GUIButton Name=ProfilesButton_btn
         Caption="Profiles"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Change your profile information."
         WinTop=0.650000
         WinLeft=0.325000
         WinWidth=0.350000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMainMenuDemo.ButtonClicked
         Name="ProfilesButton_btn"
     End Object
     ProfilesButton=GUIButton'DOTZMenu.DOTZMainMenuDemo.ProfilesButton_btn'
     Begin Object Class=GUIButton Name=settingsButton_btn
         Caption="Settings"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Change your game settings."
         WinTop=0.700000
         WinLeft=0.250000
         WinWidth=0.350000
         TabOrder=3
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMainMenuDemo.ButtonClicked
         Name="settingsButton_btn"
     End Object
     SettingsButton=GUIButton'DOTZMenu.DOTZMainMenuDemo.settingsButton_btn'
     Begin Object Class=GUIButton Name=MovieTrailerButton_btn
         Caption="Movie Trailer"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Play the movie trailer."
         WinTop=0.750000
         WinLeft=0.250000
         WinWidth=0.500000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMainMenuDemo.ButtonClicked
         Name="MovieTrailerButton_btn"
     End Object
     MovieTrailerButton=GUIButton'DOTZMenu.DOTZMainMenuDemo.MovieTrailerButton_btn'
     Begin Object Class=GUIButton Name=QuitButton_btn
         Caption="Quit"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Exit the game."
         WinTop=0.800000
         WinLeft=0.250000
         WinWidth=0.350000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMainMenuDemo.ButtonClicked
         Name="QuitButton_btn"
     End Object
     QuitButton=GUIButton'DOTZMenu.DOTZMainMenuDemo.QuitButton_btn'
     SinglePlayerMenu="DOTZMenu.DOTZSPMainMenu"
     JoinMenu="DOTZMenu.DOTZMultiplayer"
     HostMenu="DOTZMenu.DOTZBaseCreateMatch"
     ProfilesMenu="DOTZMenu.DOTZProfileMenu"
     SettingsMenu="DOTZMenu.DOTZSettingsMenu"
     QuitMenu="DOTZMenu.DOTZExitMenuDemo"
     ClickSound=Sound'DOTZXInterface.Select'
     LevelNameTxt="Loading... Theater"
     Background=Texture'DOTZTInterface.Menu.MainMenuBackGround'
     __OnKeyEvent__Delegate=DOTZMainMenuDemo.HandleKeyEvent
}
