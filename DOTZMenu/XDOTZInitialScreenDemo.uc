// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZInitialScreenDemo - initial interactive demo page
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #1 $
 * @date    June 23, 2005
 */

class XDOTZInitialScreenDemo extends XDOTZDemo;




//Page components
var Automated GUILabel   CaptionLabel;

//configurable stuff
var string ProfileSelectMenu;    // Single Player menu location
var string CancelLoadMenu;      // Single Player menu location
var string MainMenu;

var sound ClickSound;

// For playing movie
var int iteration;

// Video player
var VideoPlayer attractVideo;
var bool failed;


/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);

    attractVideo = new(self) class'BinkVideoPlayer';

    // init my components...
    // On a new reboot, we have to capture the first button press
    class'UtilsXbox'.static.Capture_Next_Controller();
    LiveCaption.bVisible = false;
}

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */

function Periodic()
{

    // Fire off the video after a while
    if (!attractVideo.VideoIsPlaying())
    {
        ++iteration;

        if (iteration >= 150) {
            Log("Playing Attract Video...");
            // TODO
            attractVideo.ScaleVideo(1.0);
            attractVideo.PlayVideo("DemoAttractMode.bik");
            iteration = 0;
        }
    }
}

function SetLoginName()
{
}

event Opened( GUIComponent Sender )
{
    super.Opened(Sender);

    Log("XDOTZInitialScreenDemo opened()");
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
 * Handle Button events
 *****************************************************************
 */

function DoButtonA ()
{
    if (attractVideo.VideoIsPlaying())
    {
        attractVideo.StopVideo();
    }
    Controller.CloseMenu(true);
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
         Caption="Please press START to begin"
         TextAlign=TXTA_Center
         TextFont="XBigFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.700000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.500000
         RenderWeight=0.900000
         Name="CaptionLabel_lbl"
     End Object
     CaptionLabel=GUILabel'DOTZMenu.XDOTZInitialScreenDemo.CaptionLabel_lbl'
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.MainMenuBackGround'
     __OnKeyEvent__Delegate=XDOTZInitialScreenDemo.HandleKeyEvent
}
