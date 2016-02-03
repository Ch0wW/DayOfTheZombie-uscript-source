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

class XDOTZLiveFriendRecvInv extends XDOTZLiveFriendBase;




//Page components
var Automated GuiButton  AcceptInvite;
var Automated GuiButton  VoiceAttachment;
var Automated GuiButton  DeclineInvite;
var Automated GuiButton  RemoveFriend;

var localized string Message;
var localized string MessageEnd;

var string ErrorMenu;
var string AttachMenu;

var sound ClickSound;


/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);

    // if we are not signed in a multiplayer game, hide the invite stuff
    if (!class'UtilsXbox'.static.Messaging_Has_Voice_Attachment() ||
        class'UtilsXbox'.static.VoiceChat_Is_Local_Banned()) {        // Hide button and move up other two
        DeclineInvite.WinTop = DeclineInvite.WinTop - 0.075;
        RemoveFriend.WinTop = RemoveFriend.WinTop - 0.075;
        RemoveComponent(VoiceAttachment, true);
        MapControls();
    }
}


/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    SetPageMessage(Message $ " " $ class'UtilsXbox'.static.Friends_Get_Game_Name() $ MessageEnd);
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
    local bool isSameTitle;
    local int error;

    if (GUIButton(Sender) != None) Selected = GUIButton(Sender);
    if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case AcceptInvite:



             // Check for cross title join
             isSameTitle = class'UtilsXbox'.static.Friends_Is_Invitation_For_Same_Title();

             if (isSameTitle) {
                 // Check for the session being available
                 class'UtilsXbox'.static.Friends_Get_Friends_Session();

                 // Check for live sign in errors
                 error = class'UtilsXbox'.static.Get_Last_Error();
                 if (error > 0) {
                    Controller.OpenMenu(ErrorMenu);
                 } else {
                     BBGuiController(Controller).SwitchMenu("DOTZMenu.XDOTZCharacterSelectInvited", "0.0.0.0");
                 }
             } else {
                 class'UtilsXbox'.static.Friends_Accept_Invitation();
                 Controller.OpenMenu("DOTZMenu.XDOTZCrossTitleWarning", class'UtilsXbox'.static.Friends_Get_Game_Name());
             }
             return false; break;

        case VoiceAttachment:
             Controller.OpenMenu(AttachMenu);
             return false; break;

        case DeclineInvite:
             Controller.OpenMenu("DOTZMenu.XDOTZLiveDeclineInv");
             //class'UtilsXbox'.static.Friends_Deny_Invitation();
             //Controller.CloseMenu(true);
             return false; break;

        case RemoveFriend:
             Controller.OpenMenu(RemoveFriendMenu);
             return false; break;
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
     Begin Object Class=GUIButton Name=AcceptInvite_btn
         Caption="Accept Invitation"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.074900
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendRecvInv.ButtonClicked
         Name="AcceptInvite_btn"
     End Object
     AcceptInvite=GUIButton'DOTZMenu.XDOTZLiveFriendRecvInv.AcceptInvite_btn'
     Begin Object Class=GUIButton Name=VoiceAttachment_btn
         Caption="Voice Attachment"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.575000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.074900
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendRecvInv.ButtonClicked
         Name="VoiceAttachment_btn"
     End Object
     VoiceAttachment=GUIButton'DOTZMenu.XDOTZLiveFriendRecvInv.VoiceAttachment_btn'
     Begin Object Class=GUIButton Name=DeclineInvite_btn
         Caption="Decline Invitation"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.650000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.074900
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendRecvInv.ButtonClicked
         Name="DeclineInvite_btn"
     End Object
     DeclineInvite=GUIButton'DOTZMenu.XDOTZLiveFriendRecvInv.DeclineInvite_btn'
     Begin Object Class=GUIButton Name=RemoveFriend_btn
         Caption="Remove Friend"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.725000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.074900
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendRecvInv.ButtonClicked
         Name="RemoveFriend_btn"
     End Object
     RemoveFriend=GUIButton'DOTZMenu.XDOTZLiveFriendRecvInv.RemoveFriend_btn'
     Message="This friend has invited you to play"
     MessageEnd="? You current progess will be lost."
     ErrorMenu="DOTZMenu.XDOTZLiveError"
     AttachMenu="DOTZMenu.XDOTZLiveFriendViewVoice"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLiveFriendRecvInv.HandleKeyEvent
}
