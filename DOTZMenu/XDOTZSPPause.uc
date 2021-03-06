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

class XDOTZSPPause extends XDOTZInGamePage;



//Page components
var Automated GuiButton  ContinueButton;
var Automated GuiButton  FriendsListButton;
var Automated GuiButton  OfflineButton;
var Automated GuiButton  RevertButton;
//var Automated GuiButton  LoadButton;
var Automated GuiButton  OptionsButton;
var Automated GuiButton  QuitButton;

var Automated GUIImage   FriendsRequestNotification;
var Automated GUIImage   FriendsInviteNotification;

//configurable stuff
var string ContinueMenu;              // Single Player menu location
var string FriendsListMenu;           // Xbox Live menu location
var string RevertMenu;
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
    Super.Initcomponent(MyController, MyOwner);

    SetPageCaption (PageCaption);
    AddBackButton ();
    AddSelectButton ();

    // if we are not signed in to live, then hide the friends menu
    if (!class'UtilsXbox'.static.Is_Signed_In()) {
        // Hide button and move up other two

        RevertButton.WinTop = RevertButton.WinTop - 0.2;
        //LoadButton.WinTop = LoadButton.WinTop - 0.2;
        OptionsButton.WinTop = OptionsButton.WinTop - 0.2;
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

    // if saving is disabled
    if (!class'UtilsXbox'.static.Get_Save_Enable()) {
       // Hide button and move up other two

        QuitButton.WinTop = QuitButton.WinTop - 0.1;

        RemoveComponent(OptionsButton, true);
        MapControls();
    }

}


/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    Refresh_Icons();

    // Add a delay before accepting input
    accept_input = false;
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
             DoButtonB ();
             return false;
             break;

        case FriendsListButton:
             return Controller.OpenMenu(FriendsListMenu);
             break;

        case RevertButton:
             return Controller.OpenMenu(RevertMenu);
             break;

        //case LoadButton:
             //return Controller.OpenMenu(LoadMenu,"true");
             //break;

        case OptionsButton:
             return Controller.OpenMenu(OptionsMenu);
             break;

        case QuitButton:
             return Controller.OpenMenu(QuitMenu);
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
    // Unpause
    Controller.ViewportOwner.Actor.Level.Game
        .SetPause( false, Controller.ViewportOwner.Actor );
    Controller.CloseAll(false);
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
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.100000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.099900
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSPPause.ButtonClicked
         Name="ContinueButton_btn"
     End Object
     ContinueButton=GUIButton'DOTZMenu.XDOTZSPPause.ContinueButton_btn'
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
         __OnClick__Delegate=XDOTZSPPause.ButtonClicked
         Name="FriendsListButton_btn"
     End Object
     FriendsListButton=GUIButton'DOTZMenu.XDOTZSPPause.FriendsListButton_btn'
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
         __OnClick__Delegate=XDOTZSPPause.ButtonClicked
         Name="OfflineButton_btn"
     End Object
     OfflineButton=GUIButton'DOTZMenu.XDOTZSPPause.OfflineButton_btn'
     Begin Object Class=GUIButton Name=RevertButton_btn
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
         __OnClick__Delegate=XDOTZSPPause.ButtonClicked
         Name="RevertButton_btn"
     End Object
     RevertButton=GUIButton'DOTZMenu.XDOTZSPPause.RevertButton_btn'
     Begin Object Class=GUIButton Name=OptionsButton_btn
         Caption="Settings"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.099900
         TabOrder=3
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSPPause.ButtonClicked
         Name="OptionsButton_btn"
     End Object
     OptionsButton=GUIButton'DOTZMenu.XDOTZSPPause.OptionsButton_btn'
     Begin Object Class=GUIButton Name=QuitButton_btn
         Caption="Quit"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.099900
         TabOrder=4
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSPPause.ButtonClicked
         Name="QuitButton_btn"
     End Object
     QuitButton=GUIButton'DOTZMenu.XDOTZSPPause.QuitButton_btn'
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
     FriendsRequestNotification=GUIImage'DOTZMenu.XDOTZSPPause.FriendsRequestNotification_icn'
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
     FriendsInviteNotification=GUIImage'DOTZMenu.XDOTZSPPause.FriendsInviteNotification_icn'
     ContinueMenu="DOTZMenu.XDOTZSPLevelList"
     FriendsListMenu="DOTZMenu.XDOTZLiveFriendsListIG"
     RevertMenu="DOTZMenu.XDOTZLoadConfirm"
     OptionsMenu="DOTZMenu.XDOTZOptionsIGSP"
     QuitMenu="DOTZMenu.XDOTZQuitConfirm"
     PageCaption="Paused"
     ClickSound=Sound'DOTZXInterface.Select'
     period=0.100000
     WinTop=0.250000
     WinHeight=0.500000
     __OnKeyEvent__Delegate=XDOTZSPPause.HandleKeyEvent
}
