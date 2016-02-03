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

class XDOTZLiveFriendRecvInvIG extends XDOTZLiveFriendBaseIG;




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
        class'UtilsXbox'.static.VoiceChat_Is_Local_Banned()) {
        // Hide button and move up other two
        DeclineInvite.WinTop = DeclineInvite.WinTop - 0.1;
        RemoveFriend.WinTop = RemoveFriend.WinTop - 0.1;
        RemoveComponent(VoiceAttachment, true);
        MapControls();
    }
}

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
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
             Controller.OpenMenu("DOTZMenu.XDOTZLiveDeclineInvIG");
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
         WinTop=0.400000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendRecvInvIG.ButtonClicked
         Name="AcceptInvite_btn"
     End Object
     AcceptInvite=GUIButton'DOTZMenu.XDOTZLiveFriendRecvInvIG.AcceptInvite_btn'
     Begin Object Class=GUIButton Name=VoiceAttachment_btn
         Caption="Voice Attachment"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendRecvInvIG.ButtonClicked
         Name="VoiceAttachment_btn"
     End Object
     VoiceAttachment=GUIButton'DOTZMenu.XDOTZLiveFriendRecvInvIG.VoiceAttachment_btn'
     Begin Object Class=GUIButton Name=DeclineInvite_btn
         Caption="Decline Invitation"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendRecvInvIG.ButtonClicked
         Name="DeclineInvite_btn"
     End Object
     DeclineInvite=GUIButton'DOTZMenu.XDOTZLiveFriendRecvInvIG.DeclineInvite_btn'
     Begin Object Class=GUIButton Name=RemoveFriend_btn
         Caption="Remove Friend"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.700000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendRecvInvIG.ButtonClicked
         Name="RemoveFriend_btn"
     End Object
     RemoveFriend=GUIButton'DOTZMenu.XDOTZLiveFriendRecvInvIG.RemoveFriend_btn'
     Message="This friend has invited you to play"
     MessageEnd="? Your current progress will be lost."
     ErrorMenu="DOTZMenu.XDOTZLiveError"
     AttachMenu="DOTZMenu.XDOTZLiveFriendViewVoiceIG"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLiveFriendRecvInvIG.HandleKeyEvent
}
