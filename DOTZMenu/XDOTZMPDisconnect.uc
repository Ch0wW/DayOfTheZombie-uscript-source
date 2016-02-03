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

class XDOTZMPDisconnect extends XDOTZInGamePage;



//Page components
var Automated GuiButton  QuitButton;
var Automated GuiButton  FriendsListButton;
var Automated GuiButton  OfflineButton;
var Automated GuiButton  PlayersListButton;
var Automated GUILabel   ErrorMessage;        // The error message to be displayed


var Automated GUIImage   FriendsRequestNotification;
var Automated GUIImage   FriendsInviteNotification;

//configurable stuff
var string FriendsListMenu;           // Xbox Live menu location
var string PlayersListMenu;           // Xbox Live menu location
var string QuitMenu;                  // Profile menu location

//configurable stuff
var localized string PageCaption;
var localized string FailedCaption;

var int tickcount;

var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);

    SetPageCaption (PageCaption);
    AddSelectButton ();

    // if we are not signed in to live, then hide the friends menu
    if (!class'UtilsXbox'.static.Is_Signed_In()) {
        // Hide button and move up other two

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

    Log("XDOTZMPDisconnect InitComponent Called");
}


/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    Refresh_Icons();

    // CARROT HACK!!!!
    SetFocus(QuitButton);
    QuitButton.SetFocus(none);

    Log("XDOTZMPDisconnect Opened Called");
}

/*****************************************************************
 * HandleParameters
 * When open menu get's called, the parameter values are supplied
 * here.
 *
 * Param1 - Alternate text
 *****************************************************************
 */
event HandleParameters( String param1, String param2 ) {

    if (param1 != "")
        SetPageCaption (param1);
}


/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled) {
   Super.Closed(Sender,bCancelled);
   Controller.MouseEmulation(false);

   Log("XDOTZMPDisconnect Closed Called");
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
    Refresh_Icons();

    ++tickcount;
    if (tickcount >= 30) {
        ErrorMessage.Caption = FailedCaption;
    }
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

    Log("XDOTZMPDisconnect ButtonClicked Called");

    switch (Selected) {
        case PlayersListButton:
             return Controller.OpenMenu(PlayersListMenu);
             break;

        case FriendsListButton:
             return Controller.OpenMenu(FriendsListMenu);
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
     Log("XDOTZMPDisconnect DoButtonB Called");
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
     Begin Object Class=GUIButton Name=QuitButton_btn
         Caption="Quit"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.700000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=3
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZMPDisconnect.ButtonClicked
         Name="QuitButton_btn"
     End Object
     QuitButton=GUIButton'DOTZMenu.XDOTZMPDisconnect.QuitButton_btn'
     Begin Object Class=GUIButton Name=FriendsListButton_btn
         Caption="Friends List"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZMPDisconnect.ButtonClicked
         Name="FriendsListButton_btn"
     End Object
     FriendsListButton=GUIButton'DOTZMenu.XDOTZMPDisconnect.FriendsListButton_btn'
     Begin Object Class=GUIButton Name=OfflineButton_btn
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZMPDisconnect.ButtonClicked
         Name="OfflineButton_btn"
     End Object
     OfflineButton=GUIButton'DOTZMenu.XDOTZMPDisconnect.OfflineButton_btn'
     Begin Object Class=GUIButton Name=PlayersListButton_btn
         Caption="Players List"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZMPDisconnect.ButtonClicked
         Name="PlayersListButton_btn"
     End Object
     PlayersListButton=GUIButton'DOTZMenu.XDOTZMPDisconnect.PlayersListButton_btn'
     Begin Object Class=GUILabel Name=ErrorMessage_lbl
         Caption="The host is not ready. Trying to reconnect..."
         TextFont="BigGuiFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.100000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.800000
         RenderWeight=0.900000
         Name="ErrorMessage_lbl"
     End Object
     ErrorMessage=GUILabel'DOTZMenu.XDOTZMPDisconnect.ErrorMessage_lbl'
     Begin Object Class=GUIImage Name=FriendsRequestNotification_icn
         Image=Texture'DOTZTInterface.XBoxIcons.FriendRequest'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.500000
         WinLeft=0.350000
         WinWidth=0.080000
         WinHeight=0.080000
         Name="FriendsRequestNotification_icn"
     End Object
     FriendsRequestNotification=GUIImage'DOTZMenu.XDOTZMPDisconnect.FriendsRequestNotification_icn'
     Begin Object Class=GUIImage Name=FriendsInviteNotification_icn
         Image=Texture'DOTZTInterface.XBoxIcons.Invite'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.500000
         WinLeft=0.350000
         WinWidth=0.080000
         WinHeight=0.080000
         Name="FriendsInviteNotification_icn"
     End Object
     FriendsInviteNotification=GUIImage'DOTZMenu.XDOTZMPDisconnect.FriendsInviteNotification_icn'
     FriendsListMenu="DOTZMenu.XDOTZLiveFriendsListIG"
     PlayersListMenu="DOTZMenu.XDOTZLivePlayersListIG"
     QuitMenu="DOTZMenu.XDOTZSPLevelList"
     FailedCaption="This game session is no longer available."
     ClickSound=Sound'DOTZXInterface.Select'
     WinTop=0.250000
     WinHeight=0.500000
     __OnKeyEvent__Delegate=XDOTZMPDisconnect.HandleKeyEvent
}
