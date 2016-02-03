// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZLiveMultiplayer
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZLiveMultiplayer extends XDOTZLivePage;



//Page components
var Automated GuiButton  QuickMatchButton;
var Automated GuiButton  OptimatchButton;
var Automated GuiButton  CreateMatchButton;
var Automated GuiButton  FriendsListButton;
//var Automated GuiButton  DashboardButton;
var Automated GuiButton  AppearOfflineButton;
var Automated GuiButton  SignOutButton;

var Automated GUIImage   FriendsRequestNotification;
var Automated GUIImage   FriendsInviteNotification;

//configurable stuff
var string QuickMatchMenu;
var string OptimatchMenu;
var string CreateMatchMenu;
var string FriendsListMenu;
//var string DashboardMenu;
var string ErrorMenu;
var string GettingMatchesMenu;



//configurable stuff
var localized string PageCaption;
var localized string appear_offline_string;             // "Appear Offline"
var localized string appear_online_string;              // "Appear Online"


var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner )
{
   Super.Initcomponent(MyController, MyOwner);
   // init my components...

   SetPageCaption (PageCaption);
   AddBackButton ();
   AddSelectButton ();

    // Check for recommended message
    if (class'UtilsXbox'.static.Is_Optional_Message()) {
        Controller.OpenMenu("DOTZMenu.XDOTZLiveMessage");
    }

    // Online/offline text
    if (class'UtilsXbox'.static.Is_Player_Online_Set()) {
        AppearOfflineButton.Caption = appear_offline_string;
    } else {
        AppearOfflineButton.Caption = appear_online_string;
    }
}


/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    Refresh_Icons();
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
    local int error;

    if (GUIButton(Sender) != None) Selected = GUIButton(Sender);
    if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case QuickMatchButton:
             // Query the match making service
             class'UtilsXbox'.static.Match_Refresh ();

             // Check errors
             error = class'UtilsXbox'.static.Get_Last_Error();
             if (error > 0) {
                Controller.OpenMenu(ErrorMenu);
             } else {
                Controller.OpenMenu(GettingMatchesMenu, "DOTZMenu.XDOTZLiveQuickMatch");
             }

             return false;
             break;

        case OptimatchButton:
             return Controller.OpenMenu(OptimatchMenu); break;

        case CreateMatchButton:
             return Controller.OpenMenu(CreateMatchMenu); break;

        case FriendsListButton:
             return Controller.OpenMenu(FriendsListMenu);
             break;

        /*case DashboardButton:
             class'UtilsXbox'.static.Do_Dashboard();
             return false;
             break; */

        case AppearOfflineButton:
             if (class'UtilsXbox'.static.Is_Player_Online_Set()) {
                 class'UtilsXbox'.static.Set_Player_Offline();
                 AppearOfflineButton.Caption = appear_online_string;
             } else {
                 class'UtilsXbox'.static.Set_Player_Online();
                 AppearOfflineButton.Caption = appear_offline_string;
             }
             break;

        case SignOutButton:
             class'UtilsXbox'.static.Sign_Out();
             return BBGuiController(Controller).CloseTo ('XDOTZLiveSignIn');
             //return Controller.OpenMenu(SignOutMenu); break;
    };

   return false;
}

/*****************************************************************
 * B Button pressed
 *****************************************************************
 */

function DoButtonB ()
{
    BBGuiController(Controller).CloseTo ('XDOTZMainMenu');
}

/*****************************************************************
 * NotifyLevelChange
 *****************************************************************
 */

event NotifyLevelChange()
{
    Controller.CloseMenu(true);
}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     Begin Object Class=GUIButton Name=QuickMatchButton_btn
         Caption="Quick Match"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.250000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveMultiplayer.ButtonClicked
         Name="QuickMatchButton_btn"
     End Object
     QuickMatchButton=GUIButton'DOTZMenu.XDOTZLiveMultiplayer.QuickMatchButton_btn'
     Begin Object Class=GUIButton Name=OptimatchButton_btn
         Caption="OptiMatch"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.340000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveMultiplayer.ButtonClicked
         Name="OptimatchButton_btn"
     End Object
     OptimatchButton=GUIButton'DOTZMenu.XDOTZLiveMultiplayer.OptimatchButton_btn'
     Begin Object Class=GUIButton Name=CreateMatchButton_btn
         Caption="Create Match"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.420000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveMultiplayer.ButtonClicked
         Name="CreateMatchButton_btn"
     End Object
     CreateMatchButton=GUIButton'DOTZMenu.XDOTZLiveMultiplayer.CreateMatchButton_btn'
     Begin Object Class=GUIButton Name=FriendsListButton_btn
         Caption="Friends List"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveMultiplayer.ButtonClicked
         Name="FriendsListButton_btn"
     End Object
     FriendsListButton=GUIButton'DOTZMenu.XDOTZLiveMultiplayer.FriendsListButton_btn'
     Begin Object Class=GUIButton Name=AppearOfflineButton_btn
         Caption="Appear Offline"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.590000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveMultiplayer.ButtonClicked
         Name="AppearOfflineButton_btn"
     End Object
     AppearOfflineButton=GUIButton'DOTZMenu.XDOTZLiveMultiplayer.AppearOfflineButton_btn'
     Begin Object Class=GUIButton Name=SignOutButton_btn
         Caption="Sign Out"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.680000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveMultiplayer.ButtonClicked
         Name="SignOutButton_btn"
     End Object
     SignOutButton=GUIButton'DOTZMenu.XDOTZLiveMultiplayer.SignOutButton_btn'
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
     FriendsRequestNotification=GUIImage'DOTZMenu.XDOTZLiveMultiplayer.FriendsRequestNotification_icn'
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
     FriendsInviteNotification=GUIImage'DOTZMenu.XDOTZLiveMultiplayer.FriendsInviteNotification_icn'
     QuickMatchMenu="DOTZMenu.XDOTZLiveQuickMatch"
     OptimatchMenu="DOTZMenu.XDOTZLiveOptiMatch"
     CreateMatchMenu="DOTZMenu.XDOTZLiveCreateMatch"
     FriendsListMenu="DOTZMenu.XDOTZLiveFriendsList"
     ErrorMenu="DOTZMenu.XDOTZLiveError"
     GettingMatchesMenu="DOTZMenu.XDOTZLiveGettingMatches"
     PageCaption="Xbox Live Multiplayer"
     appear_offline_string="Appear Offline"
     appear_online_string="Appear Online"
     ClickSound=Sound'DOTZXInterface.Select'
     period=0.050000
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLiveMultiplayer.HandleKeyEvent
}
