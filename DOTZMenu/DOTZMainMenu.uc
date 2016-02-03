// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZMainMenu - the main menu for DOTZ, based on the Warfare
 *              "GUI" package.
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #7 $
 * @date    Sept 2003
 */
class DOTZMainMenu extends DOTZPage
    implements( VideoNotification );



//Page components
var Automated GuiButton  SinglePlayerButton;
var Automated GuiButton  JoinButton;
var Automated GuiButton  HostButton;
var Automated GuiButton  ProfilesButton;
var Automated GuiButton  SettingsButton;
var Automated GuiButton  QuitButton;
//ar Automated GuiButton  MovieTrailerButton;

var Automated GUILabel   ProfileNameLbl;        // The error message to be displayed

//configurable stuff
var string SinglePlayerMenu;
var string JoinMenu;
var string HostMenu;
var string ProfilesMenu;
var string SettingsMenu;
var string QuitMenu;
var string NeedProfileMenu;

var sound ClickSound;


var VideoPlayer testVideo;

var bool bVideoIsPlaying;
var bool musicCancelled;

var localized string ProfileTxt;

 /*****************************************************************
  * InitComponent
  *****************************************************************
  */
function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);
    // init my components...

    // init my components...
    testVideo = new(self) class'BinkVideoPlayer';
    testVideo.RegisterForNotification(self); //let me know when a video ends
    Controller.OpenMenu("DOTZMenu.DOTZSelectProfile");
}


/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
  // if (PlayerOwner().Level.NetMode != NM_StandAlone){
  //    PlayerOwner().ConsoleCommand("Disconnect");
  /// }
   PlayerOwner().ConsoleCommand("Cancel");
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
 * This gets called every 1/2 second
 *****************************************************************
 */

function Periodic ()
{
    local string ProfileName;
    ProfileName = DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName();
    ProfileNameLbl.Caption = ProfileTxt @ ProfileName;

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

            if (DOTZPlayerControllerBase(PlayerOwner()).IsLoadedProfileValid())
                return Controller.OpenMenu(SinglePlayerMenu);
            else
                return Controller.OpenMenu(NeedProfileMenu);

            break;

        //JOIN GAME BUTTON
        case JoinButton:

            if (DOTZPlayerControllerBase(PlayerOwner()).IsLoadedProfileValid())
                return Controller.OpenMenu(JoinMenu);
            else
                return Controller.OpenMenu(NeedProfileMenu);

            break;

        //HOST BUTTON
        case HostButton:

            if (DOTZPlayerControllerBase(PlayerOwner()).IsLoadedProfileValid())
                return Controller.OpenMenu(HostMenu);
            else
                return Controller.OpenMenu(NeedProfileMenu);

            break;

        //PROFILES BUTTON
        case ProfilesButton:
            return Controller.OpenMenu(ProfilesMenu); break;

        //SETTINGS BUTTON
        case SettingsButton:
            return Controller.OpenMenu(SettingsMenu); break;

            /*
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
              */
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
     Begin Object Class=GUIButton Name=SinglePlayerButton_btn
         Caption="Single Player"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Play Day of the Zombie Single Player!"
         WinTop=0.360000
         WinLeft=0.325000
         WinWidth=0.350000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMainMenu.ButtonClicked
         Name="SinglePlayerButton_btn"
     End Object
     SinglePlayerButton=GUIButton'DOTZMenu.DOTZMainMenu.SinglePlayerButton_btn'
     Begin Object Class=GUIButton Name=JoinGameButton_btn
         Caption="Join Multiplayer Game"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Join a Day of the Zombie Multiplayer match."
         WinTop=0.410000
         WinLeft=0.325000
         WinWidth=0.350000
         TabOrder=2
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMainMenu.ButtonClicked
         Name="JoinGameButton_btn"
     End Object
     JoinButton=GUIButton'DOTZMenu.DOTZMainMenu.JoinGameButton_btn'
     Begin Object Class=GUIButton Name=HostGameButton_btn
         Caption="Host Multiplayer Game"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Set up a Day of the Zombie Multiplayer match."
         WinTop=0.460000
         WinLeft=0.325000
         WinWidth=0.350000
         TabOrder=3
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMainMenu.ButtonClicked
         Name="HostGameButton_btn"
     End Object
     HostButton=GUIButton'DOTZMenu.DOTZMainMenu.HostGameButton_btn'
     Begin Object Class=GUIButton Name=ProfilesButton_btn
         Caption="Profiles"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Change your profile information."
         WinTop=0.510000
         WinLeft=0.325000
         WinWidth=0.350000
         TabOrder=4
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMainMenu.ButtonClicked
         Name="ProfilesButton_btn"
     End Object
     ProfilesButton=GUIButton'DOTZMenu.DOTZMainMenu.ProfilesButton_btn'
     Begin Object Class=GUIButton Name=settingsButton_btn
         Caption="Settings"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Change your game settings."
         WinTop=0.560000
         WinLeft=0.325000
         WinWidth=0.350000
         TabOrder=5
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMainMenu.ButtonClicked
         Name="settingsButton_btn"
     End Object
     SettingsButton=GUIButton'DOTZMenu.DOTZMainMenu.settingsButton_btn'
     Begin Object Class=GUIButton Name=QuitButton_btn
         Caption="Exit Game"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Exit the game."
         WinTop=0.610000
         WinLeft=0.325000
         WinWidth=0.350000
         TabOrder=6
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMainMenu.ButtonClicked
         Name="QuitButton_btn"
     End Object
     QuitButton=GUIButton'DOTZMenu.DOTZMainMenu.QuitButton_btn'
     Begin Object Class=GUILabel Name=ProfileMessage_lbl
         Caption="Profile: "
         TextFont="PlainGuiFont"
         bMultiLine=True
         bScaleToParent=True
         WinTop=0.950000
         WinLeft=0.050000
         WinWidth=0.800000
         WinHeight=0.800000
         RenderWeight=0.900000
         Name="ProfileMessage_lbl"
     End Object
     ProfileNameLbl=GUILabel'DOTZMenu.DOTZMainMenu.ProfileMessage_lbl'
     SinglePlayerMenu="DOTZMenu.DOTZSPMainMenu"
     JoinMenu="DOTZMenu.DOTZJoinMenu"
     HostMenu="DOTZMenu.DOTZBaseCreateMatch"
     ProfilesMenu="DOTZMenu.DOTZProfileMenu"
     SettingsMenu="DOTZMenu.DOTZSettingsMenu"
     QuitMenu="DOTZMenu.DOTZQuitConfirm"
     NeedProfileMenu="DOTZMenu.DOTZProfileForceSelect"
     ClickSound=Sound'DOTZXInterface.Select'
     ProfileTxt="Profile: "
     Background=Texture'DOTZTInterface.Menu.MainMenuBackGround'
     __OnKeyEvent__Delegate=DOTZMainMenu.HandleKeyEvent
}
