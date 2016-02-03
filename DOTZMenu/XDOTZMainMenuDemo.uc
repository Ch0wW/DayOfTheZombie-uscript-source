// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZMainMenuzzzDemo - the main menu for Xbox DOTZ Demo, based on the Warfare
 *              "GUI" package.
 * - ripped off of XDOTZMainMenu for the original Xbox DOTZ
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #1 $
 * @date    June 20, 2005
 */

class XDOTZMainMenuDemo extends XDOTZDemo;




//Page components
var Automated GuiButton  SinglePlayerButton;
var Automated GuiButton  XboxLiveButton;
var Automated GuiButton  SystemLinkButton;
var Automated GuiButton  ProfileButton;
var Automated GuiButton  ExitButton;

var config bool bFirstRun;

//configurable stuff
var string SinglePlayerMenu;    // Single Player menu location
var string ProfileMenu;         // Profile menu location
var string ExitConfirmMenu;     // Exit confirmation menu
var string InitialScreen;

var sound ClickSound;

var VideoPlayer testVideo;
var int menuMusicHandle;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);


    // init my components...
    testVideo = new(self) class'BinkVideoPlayer';

    LiveCaption.bVisible = false;
}


/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender )
{
    super.Opened(Sender);


    // If this is the first time, launch the initial screen demo
    /*
    bFirstRun = class'XDOTZMainMenuDemo'.default.bFirstRun;
    if(bFirstRun)
    {
        class'XDOTZMainMenuDemo'.default.bFirstRun = false;
        class'XDOTZMainMenuDemo'.static.StaticSaveConfig();
        Controller.OpenMenu(InitialScreen);
    }
    */
    if(menuMusicHandle == -1)
    {
        // Play menu music if first time opened
        menuMusicHandle = PlayerOwner().PlayMusic("Z16", 0.5);
    }

    if(class'Profiler'.static.GetValue("bAlreadyRan") != "true")
    {
        class'Profiler'.static.SetValue("bAlreadyRan", "true");
        Controller.OpenMenu(InitialScreen);
    }

    // If its launched by CDX, show the exit game option
    if(class'UtilsXbox'.static.Get_Demo_Mode() == 1)
    {
        ExitButton.SetVisibility(true);

        // Manually link the buttons to each other
        SinglePlayerButton.SetLinks(ExitButton,ProfileButton,none,none);
        ProfileButton.SetLinks(SinglePlayerButton,ExitButton,none,none);
        ExitButton.SetLinks(ProfileButton, SinglePlayerButton,none,none);

    } else
    {
        ExitButton.SetVisibility(false);
        // Manually link the buttons to each other
        SinglePlayerButton.SetLinks(ProfileButton,ProfileButton,none,none);
        ProfileButton.SetLinks(SinglePlayerButton,SinglePlayerButton,none,none);
        //ExitButton.SetLinks(ProfileButton, SinglePlayerButton,none,none);

    }
}

/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled) {
    if(menuMusicHandle != -1)
    {
        PlayerOwner().StopMusic(menuMusicHandle, 0.0);
        menuMusicHandle = -1;
    }
    Super.Closed(Sender,bCancelled);
    Controller.MouseEmulation(false);
}

/*****************************************************************
 * This gets called every 1/2 second
 *****************************************************************
 */

function Periodic ()
{
    //super.Periodic();
}

function SetLoginName()
{
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
        case SinglePlayerButton:
             // Unpause game and close menu
             Controller.ViewportOwner.Actor.Level.Game
                .SetPause( false, Controller.ViewportOwner.Actor );
             return Controller.CloseMenu(true);
             break;

        case ProfileButton:
             Controller.OpenMenu(ProfileMenu);
             break;

        case ExitButton:
             Controller.OpenMenu(ExitConfirmMenu);
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
     Begin Object Class=GUIButton Name=SinglePlayerButton_btn
         Caption="Single Player"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZMainMenuDemo.ButtonClicked
         Name="SinglePlayerButton_btn"
     End Object
     SinglePlayerButton=GUIButton'DOTZMenu.XDOTZMainMenuDemo.SinglePlayerButton_btn'
     Begin Object Class=GUIButton Name=XboxLiveButton_btn
         Caption="Xbox Live"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bAcceptsInput=False
         bNeverFocus=True
         WinTop=0.560000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         Name="XboxLiveButton_btn"
     End Object
     XboxLiveButton=GUIButton'DOTZMenu.XDOTZMainMenuDemo.XboxLiveButton_btn'
     Begin Object Class=GUIButton Name=SystemLinkButton_btn
         Caption="System Link"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bAcceptsInput=False
         bNeverFocus=True
         WinTop=0.620000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=2
         Name="SystemLinkButton_btn"
     End Object
     SystemLinkButton=GUIButton'DOTZMenu.XDOTZMainMenuDemo.SystemLinkButton_btn'
     Begin Object Class=GUIButton Name=ProfileButton_btn
         Caption="Settings"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.680000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=3
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZMainMenuDemo.ButtonClicked
         Name="ProfileButton_btn"
     End Object
     ProfileButton=GUIButton'DOTZMenu.XDOTZMainMenuDemo.ProfileButton_btn'
     Begin Object Class=GUIButton Name=ExitButton_btn
         Caption="Exit Demo"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         WinTop=0.740000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=4
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZMainMenuDemo.ButtonClicked
         Name="ExitButton_btn"
     End Object
     ExitButton=GUIButton'DOTZMenu.XDOTZMainMenuDemo.ExitButton_btn'
     SinglePlayerMenu="DOTZMenu.XDOTZSPMainMenu"
     ProfileMenu="DOTZMenu.XDOTZProfileEditSettingsDemo"
     ExitConfirmMenu="DOTZMenu.XDOTZExitDemo"
     InitialScreen="DOTZMenu.XDOTZInitialScreenDemo"
     ClickSound=Sound'DOTZXInterface.Select'
     menuMusicHandle=-1
     period=0.500000
     Background=Texture'DOTZTInterface.Menu.MainMenuBackGround'
     __OnKeyEvent__Delegate=XDOTZMainMenuDemo.HandleKeyEvent
}
