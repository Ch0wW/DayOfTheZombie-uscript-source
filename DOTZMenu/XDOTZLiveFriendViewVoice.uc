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

class XDOTZLiveFriendViewVoice extends XDOTZLiveFriendBase;




//Page components
var Automated GuiButton  PlayVoiceAttachment;
var Automated GuiButton  OffensiveMessageFeedback;

var localized string Message;

var string ErrorMenu;
var string OffensiveMsgMenu;    // Single Player menu location

var sound ClickSound;


/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);

    class'UtilsXbox'.static.Messaging_Download_Voice_Attachment();
}


/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    SetPageMessage(Message $ " " $ class'UtilsXbox'.static.Friends_Get_Game_Name());


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
        case PlayVoiceAttachment:
             Controller.OpenMenu(PlayVoiceMenu);
             return false; break;

        case OffensiveMessageFeedback:
             Controller.OpenMenu(   OffensiveMsgMenu,
                                    class'UtilsXbox'.static.Messaging_Get_Sender_Gamertag(),
                                    class'UtilsXbox'.static.Messaging_Get_Sender_XUID() );
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
     Begin Object Class=GUIButton Name=PlayVoiceAttachment_btn
         Caption="Play Voice Attachment"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.074900
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendViewVoice.ButtonClicked
         Name="PlayVoiceAttachment_btn"
     End Object
     PlayVoiceAttachment=GUIButton'DOTZMenu.XDOTZLiveFriendViewVoice.PlayVoiceAttachment_btn'
     Begin Object Class=GUIButton Name=OffensiveMessageFeedback_btn
         Caption="Offensive Message"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.575000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.074900
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendViewVoice.ButtonClicked
         Name="OffensiveMessageFeedback_btn"
     End Object
     OffensiveMessageFeedback=GUIButton'DOTZMenu.XDOTZLiveFriendViewVoice.OffensiveMessageFeedback_btn'
     Message="Voice mail attachment"
     ErrorMenu="DOTZMenu.XDOTZLiveError"
     OffensiveMsgMenu="DOTZMenu.XDOTZLiveComplaintOffensiveMsg"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLiveFriendViewVoice.HandleKeyEvent
}
