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

class XDOTZLiveFriendRecvReqIG extends XDOTZLiveFriendBaseIG;




//Page components
var Automated GuiButton  AcceptRequest;
var Automated GuiButton  VoiceAttachment;
var Automated GuiButton  DeclineRequest;
var Automated GuiButton  BlockRequest;

var localized string Message;

var sound ClickSound;

//configurable stuff
var string BlockFriendMenu;    // Single Player menu location
var string AttachMenu;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);

    // if we are not signed in a multiplayer game, hide the invite stuff
    if (!class'UtilsXbox'.static.Messaging_Has_Voice_Attachment() ||
        class'UtilsXbox'.static.VoiceChat_Is_Local_Banned()) {        // Hide button and move up other two
        DeclineRequest.WinTop = DeclineRequest.WinTop - 0.1;
        BlockRequest.WinTop = BlockRequest.WinTop - 0.1;
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

    SetPageMessage(Message);
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

    if (GUIButton(Sender) != None) Selected = GUIButton(Sender);
    if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case AcceptRequest:
             class'UtilsXbox'.static.Friends_Accept_Friend_Request();
             Controller.CloseMenu(true);
             return false; break;

        case VoiceAttachment:
             Controller.OpenMenu(AttachMenu);
             return false; break;

        case DeclineRequest:
             //class'UtilsXbox'.static.Friends_Deny_Friend_Request();
             //Controller.CloseMenu(true);
             Controller.OpenMenu("DOTZMenu.XDOTZLiveDeclineFriendIG");
             return false; break;

        case BlockRequest:
             Controller.OpenMenu(BlockFriendMenu);
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
     Begin Object Class=GUIButton Name=AcceptRequest_btn
         Caption="Accept Request"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendRecvReqIG.ButtonClicked
         Name="AcceptRequest_btn"
     End Object
     AcceptRequest=GUIButton'DOTZMenu.XDOTZLiveFriendRecvReqIG.AcceptRequest_btn'
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
         __OnClick__Delegate=XDOTZLiveFriendRecvReqIG.ButtonClicked
         Name="VoiceAttachment_btn"
     End Object
     VoiceAttachment=GUIButton'DOTZMenu.XDOTZLiveFriendRecvReqIG.VoiceAttachment_btn'
     Begin Object Class=GUIButton Name=DeclineRequest_btn
         Caption="Decline Request"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendRecvReqIG.ButtonClicked
         Name="DeclineRequest_btn"
     End Object
     DeclineRequest=GUIButton'DOTZMenu.XDOTZLiveFriendRecvReqIG.DeclineRequest_btn'
     Begin Object Class=GUIButton Name=BlockRequest_btn
         Caption="Block Requests"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.700000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendRecvReqIG.ButtonClicked
         Name="BlockRequest_btn"
     End Object
     BlockRequest=GUIButton'DOTZMenu.XDOTZLiveFriendRecvReqIG.BlockRequest_btn'
     Message="This player has requested to be added to your friends list. What do you want to do?"
     ClickSound=Sound'DOTZXInterface.Select'
     BlockFriendMenu="DOTZMenu.XDOTZLiveBlockFriendIG"
     AttachMenu="DOTZMenu.XDOTZLiveFriendViewVoiceIG"
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLiveFriendRecvReqIG.HandleKeyEvent
}
