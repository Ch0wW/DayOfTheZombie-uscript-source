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

class XDOTZLivePlayerSelectIG extends XDOTZLivePlayerBaseIG;




//Page components
var Automated GuiButton     VoiceStatusButton;
var Automated GuiButton     FeedbackButton;
var Automated GuiButton     CancelRequestButton;
var Automated GuiButton     FriendRequestButton;

var localized string Message;

var localized string IsMutedString;
var localized string IsNotMutedString;

// Menus
var string PlayerFeedbackMenu;
//var string RemoveFriendMenu;

var sound ClickSound;

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
    super.Opened(Sender);
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
    super.HandleParameters(param1, param2);

    SetPageMessage(Message $ " " $ Gamertag);

    Periodic ();
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

function Periodic ()
{
    local bool muted;

    super.Periodic();

    // Refresh the friends list to get updated statuses
    class'UtilsXbox'.static.Friends_Refresh_List ();
    class'UtilsXbox'.static.Friends_Select_By_XUID (Xuid);
    class'UtilsXbox'.static.VoiceChat_Select_Talker_By_XUID (Xuid);

    // Is the selected friend muted?
    muted = class'UtilsXbox'.static.VoiceChat_Mute_List_Is_Muted ();

    // Toggle the mute status
    if (muted) {
        VoiceStatusButton.Caption = IsMutedString;
        Log("Voice: Muted");
    } else {
        VoiceStatusButton.Caption = IsNotMutedString;
        Log("Voice: On");
    }

    // Update friend button
    if (class'UtilsXbox'.static.Friends_Get_Selected () >= 0 &&
        !class'UtilsXbox'.static.Friends_Is_Sent_Friend_Request()) {

        CancelRequestButton.bVisible = false;
        CancelRequestButton.bNeverFocus = true;

        FriendRequestButton.bVisible = false;
        FriendRequestButton.bNeverFocus = true;

    } else if (class'UtilsXbox'.static.Friends_Get_Selected () >= 0 &&
        class'UtilsXbox'.static.Friends_Is_Sent_Friend_Request()) {

        CancelRequestButton.bVisible = true;
        CancelRequestButton.bNeverFocus = false;

        FriendRequestButton.bVisible = false;
        FriendRequestButton.bNeverFocus = true;

    } else {

        CancelRequestButton.bVisible = false;
        CancelRequestButton.bNeverFocus = true;

        FriendRequestButton.bVisible = true;
        FriendRequestButton.bNeverFocus = false;

    }

    MapControls();
}

/*****************************************************************
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */
function bool ButtonClicked(GUIComponent Sender) {
    local GUIButton Selected;
    local bool muted;

    if (GUIButton(Sender) != None) Selected = GUIButton(Sender);
    if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case VoiceStatusButton:
             muted = class'UtilsXbox'.static.VoiceChat_Mute_List_Is_Muted ();

             if (muted) {
                 class'UtilsXbox'.static.VoiceChat_Mute_List_Remove ();
             } else {
                 class'UtilsXbox'.static.VoiceChat_Mute_List_Add ();
             }

             accept_input = false;

             return false;
             break;

        case FeedbackButton:
             // Open the manage player menu
             Controller.OpenMenu(PlayerFeedbackMenu, GamerTag, Xuid);

             return false;
             break;

        case CancelRequestButton:
             Controller.OpenMenu("DOTZMenu.XDOTZLiveCancelFriendReqPLIG");
             //class'UtilsXbox'.static.Friends_Cancel_Friend_Request();
             //Controller.CloseMenu(false);
             return false;
             break;

        case FriendRequestButton:
             if (!class'UtilsXbox'.static.VoiceChat_Is_Local_Banned()) {
                BBGuiController(Controller).SwitchMenu("DOTZMenu.XDOTZLivePlayerVoiceMailOptionIG",Gamertag,Xuid);
             } else {
                class'UtilsXbox'.static.Friends_Send_Friend_Request_With_Voice(Xuid);
                Controller.CloseMenu(false);
             }

             return false;
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
     Begin Object Class=GUIButton Name=VoiceStatusButton_btn
         Caption="Voice On"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLivePlayerSelectIG.ButtonClicked
         Name="VoiceStatusButton_btn"
     End Object
     VoiceStatusButton=GUIButton'DOTZMenu.XDOTZLivePlayerSelectIG.VoiceStatusButton_btn'
     Begin Object Class=GUIButton Name=FeedbackButton_btn
         Caption="Send Feedback"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLivePlayerSelectIG.ButtonClicked
         Name="FeedbackButton_btn"
     End Object
     FeedbackButton=GUIButton'DOTZMenu.XDOTZLivePlayerSelectIG.FeedbackButton_btn'
     Begin Object Class=GUIButton Name=CancelRequestButton_btn
         Caption="Cancel Friend Request"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.600000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLivePlayerSelectIG.ButtonClicked
         Name="CancelRequestButton_btn"
     End Object
     CancelRequestButton=GUIButton'DOTZMenu.XDOTZLivePlayerSelectIG.CancelRequestButton_btn'
     Begin Object Class=GUIButton Name=FriendRequestButton_btn
         Caption="Request Friend"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.600000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLivePlayerSelectIG.ButtonClicked
         Name="FriendRequestButton_btn"
     End Object
     FriendRequestButton=GUIButton'DOTZMenu.XDOTZLivePlayerSelectIG.FriendRequestButton_btn'
     Message="What do you want to do with"
     IsMutedString="Voice Muted"
     IsNotMutedString="Voice On"
     PlayerFeedbackMenu="DOTZMenu.XDOTZLivePlayerFeedbackIG"
     ClickSound=Sound'DOTZXInterface.Select'
     period=0.100000
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLivePlayerSelectIG.HandleKeyEvent
}
