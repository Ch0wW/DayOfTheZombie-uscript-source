// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZProfileSelectMenu - the main menu for Xbox DOTZ, based on the Warfare
 *              "GUI" package.
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZInitialScreen extends XDOTZPage;





const CHECK_CONTROLLER_AND_SYSLINK    = 6969;

//Page components
var Automated GUILabel   CaptionLabel;

//configurable stuff
var string ProfileSelectMenu;    // Single Player menu location
var string CancelLoadMenu;      // Single Player menu location
var string MainMenu;

// Initial strings
var localized string ConnectSystemLinkText;
var localized string ConnectLiveText;

var sound ClickSound;

// For playing movie
var int iteration;

// Video player
var VideoPlayer attractVideo;
var bool failed;
var bool musicCancelled;

// Profiles
//var Profiler profiles;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);
    attractVideo = new(self) class'BinkVideoPlayer';
    //profiles = new(self) class'DOTZProfiler';

    // init my components...
}


/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */

function Periodic()
{
    // Fire off the video after a while
    if (!attractVideo.VideoIsPlaying()) {

        // Restart music if it was cancelled
        if (musicCancelled) {
            PlayerOwner().PlayMusic(PlayerOwner().Level.Song,0.1);
            musicCancelled = false;
        }

        ++iteration;

        if (iteration >= 300) {

            //to cover the case where they have interrupted attract mode
            //but did not go to the next screen
            //class'UtilsXbox'.static.Clear_Captured_Controller();
            //log("clearing the captured controller");

            Log("Playing Attract Video...");

            PlayerOwner().StopAllMusic(0.1);
            musicCancelled = true;

            attractVideo.ScaleVideo(1.0);
            attractVideo.PlayVideo("AttractMode.bik");
            iteration = 0;
        }


    }

}

event Opened( GUIComponent Sender ) {
     local int reboot_type;

     super.Opened(Sender);

     reboot_type = class'UtilsXbox'.static.Get_Reboot_Type();

     // Are we returning from singleplayer
     if (reboot_type == 6 || reboot_type == 8 || reboot_type == 8) {
        // Automatically go to next screen
        Controller.OpenMenu(MainMenu);

     // if the reboot type > 0, then it's going to a level.
     } else if (reboot_type > 0) {
        Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenuConnecting");

        /*switch(reboot_type) {
            case 2:     CaptionLabel.Caption = ConnectSystemLinkText;      break;
            case 4:     CaptionLabel.Caption = ConnectLiveText;            break;
        };*/

        //AddBackButton();

     } else {
        // On a new reboot, we have to capture the first button press
        AdvancedPlayerController(PlayerOwner()).SetMultiTimer( CHECK_CONTROLLER_AND_SYSLINK, 0, false);
        //class'UtilsXbox'.static.Capture_Next_Controller();
     }
}

/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled) {
     Super.Closed(Sender,bCancelled);
     AdvancedPlayerController(PlayerOwner()).SetMultiTimer( CHECK_CONTROLLER_AND_SYSLINK, 0.5, true);
     Controller.MouseEmulation(false);
}

/*****************************************************************
 * Handle Button events
 *****************************************************************
 */
function DoButtonA ()
{
     local int reboot_type;

     reboot_type = class'UtilsXbox'.static.Get_Reboot_Type();
     // If the reboot type > 0, then it's going to a level.
     if (reboot_type > 0) {
         // TODO: Fixme
         //Controller.CloseAll(true);
         //class'UtilsXbox'.static.Capture_Next_Controller();
         Controller.OpenMenu(CancelLoadMenu);
     } else {

         // Reset the video if playing
         if (attractVideo.VideoIsPlaying())  {
             attractVideo.StopVideo();
             iteration = 0;

             //class'UtilsXbox'.static.Clear_Captured_Controller();


         // Proceed to next menu
         } else {
             class'UtilsXbox'.static.Capture_Next_Controller();

             // Cancel the timer
             SetTimer(0,false);

             // Start auto sign in
             if (!class'UtilsXbox'.static.Is_Cross_Title_Invite() &&
                 !class'UtilsXbox'.static.Is_Signed_In() && reboot_type == 0) {

                class'UtilsXbox'.static.Attempt_Silent_Sign_In();
                class'UtilsXbox'.static.Set_Last_Error(0);

             }

             if (DOTZPlayerControllerBase(PlayerOwner()).GetProfileCount() > 0 && class'UtilsXbox'.static.Get_Save_Enable()) {
                BBGuiController(Controller).SwitchMenu (ProfileSelectMenu);
             } else {
                BBGuiController(Controller).SwitchMenu (MainMenu);
             }
         }
     }
}

function DoButtonB ()
{
    DoButtonA ();
}

function DoButtonStart ()
{
    DoButtonA ();
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
     Begin Object Class=GUILabel Name=CaptionLabel_lbl
         Caption="Press START to begin"
         TextAlign=TXTA_Center
         TextFont="XBigFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.610000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.500000
         RenderWeight=0.900000
         Name="CaptionLabel_lbl"
     End Object
     CaptionLabel=GUILabel'DOTZMenu.XDOTZInitialScreen.CaptionLabel_lbl'
     ProfileSelectMenu="DOTZMenu.XDOTZProfileSelectIntro"
     CancelLoadMenu="DOTZMenu.XDOTZMPCancelConnect"
     MainMenu="DOTZMenu.XDOTZMainMenu"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.MainMenuBackGround'
     __OnKeyEvent__Delegate=XDOTZInitialScreen.HandleKeyEvent
}
