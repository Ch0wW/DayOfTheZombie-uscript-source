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

class XDOTZLiveFriendSendInviteVoiceIG extends XDOTZLiveFriendBaseIG;




//Page components

var Automated GuiButton  ClearVoiceMail;
var Automated GuiButton  RecordVoiceMail;
var Automated GuiButton  PlayVoiceMail;
var Automated GuiButton  InviteFriend;

var localized string Message;

var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);

    class'UtilsXbox'.static.VoiceChat_Clear_Voice_Mail();
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

   class'UtilsXbox'.static.VoiceChat_Clear_Voice_Mail();
}

/*****************************************************************
 * B Button pressed
 *
 *****************************************************************
 */

function DoButtonB ()
{
    BBGuiController(Controller).CloseTo ('XDOTZLiveFriendsListIG');
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
        case InviteFriend:
             class'UtilsXbox'.static.Friends_Send_Invitation_With_Voice();
             BBGuiController(Controller).CloseTo('XDOTZLiveFriendsListIG');
             return false; break;

        case ClearVoiceMail:
             Controller.OpenMenu(ClearVoiceMenu);
             return false; break;

        case RecordVoiceMail:
             if (class'UtilsXbox'.static.VoiceChat_Is_Local_Enabled()) {
                Controller.OpenMenu(RecordVoiceMenu);
             }
             return false; break;

        case PlayVoiceMail:
             if (class'UtilsXbox'.static.VoiceChat_Is_Local_Enabled()) {
                Controller.OpenMenu(PlayVoiceMenu);
             }
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
     Begin Object Class=GUIButton Name=ClearVoiceMail_btn
         Caption="Clear Voice Mail"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.300000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendSendInviteVoiceIG.ButtonClicked
         Name="ClearVoiceMail_btn"
     End Object
     ClearVoiceMail=GUIButton'DOTZMenu.XDOTZLiveFriendSendInviteVoiceIG.ClearVoiceMail_btn'
     Begin Object Class=GUIButton Name=RecordVoiceMail_btn
         Caption="Record Voice Mail"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendSendInviteVoiceIG.ButtonClicked
         Name="RecordVoiceMail_btn"
     End Object
     RecordVoiceMail=GUIButton'DOTZMenu.XDOTZLiveFriendSendInviteVoiceIG.RecordVoiceMail_btn'
     Begin Object Class=GUIButton Name=PlayVoiceMail_btn
         Caption="Play Voice Mail"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendSendInviteVoiceIG.ButtonClicked
         Name="PlayVoiceMail_btn"
     End Object
     PlayVoiceMail=GUIButton'DOTZMenu.XDOTZLiveFriendSendInviteVoiceIG.PlayVoiceMail_btn'
     Begin Object Class=GUIButton Name=InviteFriend_btn
         Caption="Invite Friend"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendSendInviteVoiceIG.ButtonClicked
         Name="InviteFriend_btn"
     End Object
     InviteFriend=GUIButton'DOTZMenu.XDOTZLiveFriendSendInviteVoiceIG.InviteFriend_btn'
     Message="Do you want to attach a voice message?"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLiveFriendSendInviteVoiceIG.HandleKeyEvent
}
