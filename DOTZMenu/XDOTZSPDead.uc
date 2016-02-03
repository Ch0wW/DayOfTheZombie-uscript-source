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

class XDOTZSPDead extends XDOTZInGamePage;



//Page components
var Automated GuiButton  FriendsListButton;
var Automated GuiButton  OfflineButton;
var Automated GuiButton  RevertToLastSaveButton;
var Automated GuiButton  QuitButton;

var Automated GUIImage   FriendsRequestNotification;
var Automated GUIImage   FriendsInviteNotification;

//configurable stuff
var string FriendsListMenu;           // Xbox Live menu location
var string RevertToLastSaveMenu;      // System Link menu location
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

    Log(self $ "InitComponent");
    SetPageCaption (PageCaption);
    //AddBackButton ();
    AddSelectButton ();

    // if we are not signed in to live, then hide the friends menu
    if (!class'UtilsXbox'.static.Is_Signed_In()) {
        // Hide button and move up other two

        RevertToLastSaveButton.WinTop = RevertToLastSaveButton.WinTop - 0.2;
        QuitButton.WinTop = QuitButton.WinTop - 0.2;

        RemoveComponent(FriendsListButton, true);
        RemoveComponent(OfflineButton, true);
        MapControls();
    } else {
        if (class'UtilsXbox'.static.Is_Player_Online_Set()) {
            OfflineButton.Caption = appear_offline_string;
        } else {
            OfflineButton.Caption = appear_online_string;
        }
    }
}


/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    Log(self $ "Opened");
    Refresh_Icons();

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
 * This gets called every 1/2 second
 *****************************************************************
 */

function Refresh_Icons ()
{
    class'UtilsXbox'.static.Friends_Refresh_List();

    if (class'UtilsXbox'.static.Is_Signed_In()) {
        if (class'UtilsXbox'.static.Friends_Is_Any_Recv_Invitation()) {
            FriendsRequestNotification.bVisible = false;
            FriendsInviteNotification.bVisible = true;
        } else if (class'UtilsXbox'.static.Friends_Is_Any_Recv_Friend_Request()) {
            FriendsRequestNotification.bVisible = true;
            FriendsInviteNotification.bVisible = false;
        } else {
            FriendsRequestNotification.bVisible = false;
            FriendsInviteNotification.bVisible = false;
        }
    } else {
        FriendsRequestNotification.bVisible = false;
        FriendsInviteNotification.bVisible = false;
    }
}

function Periodic ()
{
    super.Periodic();
    Log(self $ "Periodic");
    Refresh_Icons();
}

/*****************************************************************
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */
function bool ButtonClicked(GUIComponent Sender) {
    local GUIButton Selected;
    local string mapname;

    if (GUIButton(Sender) != None) Selected = GUIButton(Sender);
    if (Selected == None) return false;

    PlayerOwner().PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case FriendsListButton:
             return Controller.OpenMenu(FriendsListMenu);
             break;

        case RevertToLastSaveButton:

            // Display loading screen
            Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu");

            mapname = GameSpecificLevelInfo(PlayerOwner().Level.GameSpecificLevelInfo).LevelName
                 @ "-" @ "Checkpoint" @ PlayerOwner().Level.ActiveCheckPointID;

            // Load to last checkpoint
            Controller.ConsoleCommand( "loadcheckpoint \"" $ mapname $ "\"");
            break;

        case QuitButton:

             class'UtilsXbox'.static.Set_Reboot_Type(6);   // IS_RETURN_FROM_SINGLE_PLAYER

             // Display loading screen
             Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu");

             // Reboot!
             Console(Controller.Master.Console).ConsoleCommand("reboot");  // URL not part of command on xbox

             //return Controller.OpenMenu(QuitMenu);
             break;

        case OfflineButton:
             if (class'UtilsXbox'.static.Is_Player_Online_Set()) {
                 class'UtilsXbox'.static.Set_Player_Offline();
                 OfflineButton.Caption = appear_online_string;
             } else {
                 class'UtilsXbox'.static.Set_Player_Online();
                 OfflineButton.Caption = appear_offline_string;
             }
             break;
    };

   return false;
}

/*****************************************************************
 * Continue if B pressed too
 *
 *****************************************************************
 */

function DoButtonB ()
{

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
     Begin Object Class=GUIButton Name=FriendsListButton_btn
         Caption="Friends List"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.200000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.099900
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSPDead.ButtonClicked
         Name="FriendsListButton_btn"
     End Object
     FriendsListButton=GUIButton'DOTZMenu.XDOTZSPDead.FriendsListButton_btn'
     Begin Object Class=GUIButton Name=OfflineButton_btn
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.300000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.099900
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSPDead.ButtonClicked
         Name="OfflineButton_btn"
     End Object
     OfflineButton=GUIButton'DOTZMenu.XDOTZSPDead.OfflineButton_btn'
     Begin Object Class=GUIButton Name=RevertToLastSaveButton_btn
         Caption="Load Last Checkpoint"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.099900
         TabOrder=2
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSPDead.ButtonClicked
         Name="RevertToLastSaveButton_btn"
     End Object
     RevertToLastSaveButton=GUIButton'DOTZMenu.XDOTZSPDead.RevertToLastSaveButton_btn'
     Begin Object Class=GUIButton Name=QuitButton_btn
         Caption="Quit"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.099900
         TabOrder=3
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSPDead.ButtonClicked
         Name="QuitButton_btn"
     End Object
     QuitButton=GUIButton'DOTZMenu.XDOTZSPDead.QuitButton_btn'
     Begin Object Class=GUIImage Name=FriendsRequestNotification_icn
         Image=Texture'DOTZTInterface.XBoxIcons.FriendRequest'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.200000
         WinLeft=0.350000
         WinWidth=0.080000
         WinHeight=0.080000
         Name="FriendsRequestNotification_icn"
     End Object
     FriendsRequestNotification=GUIImage'DOTZMenu.XDOTZSPDead.FriendsRequestNotification_icn'
     Begin Object Class=GUIImage Name=FriendsInviteNotification_icn
         Image=Texture'DOTZTInterface.XBoxIcons.Invite'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.200000
         WinLeft=0.350000
         WinWidth=0.080000
         WinHeight=0.080000
         Name="FriendsInviteNotification_icn"
     End Object
     FriendsInviteNotification=GUIImage'DOTZMenu.XDOTZSPDead.FriendsInviteNotification_icn'
     FriendsListMenu="DOTZMenu.XDOTZLiveFriendsListIG"
     RevertToLastSaveMenu="DOTZMenu.XDOTZLoadConfirm"
     QuitMenu="DOTZMenu.XDOTZSPLevelList"
     PageCaption="You Died Loser"
     ClickSound=Sound'DOTZXInterface.Select'
     WinTop=0.250000
     WinHeight=0.500000
     __OnKeyEvent__Delegate=XDOTZSPDead.HandleKeyEvent
}
