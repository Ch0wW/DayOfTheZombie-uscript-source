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

class XDOTZLivePlayerBaseIG extends XDOTZLiveFriendsListBaseIG;




//Page components
var Automated GUILabel   Message;

//configurable stuff
var string RemoveFriendMenu;    // Single Player menu location
var string RequestFriendMenu;
var string RecordVoiceMenu;    // Single Player menu location
var string PlayVoiceMenu;    // Single Player menu location
var string ClearVoiceMenu;    // Single Player menu location


// Parameters
var string GamerTag;
var string Xuid;

// Sound
var sound ClickSound;

/*****************************************************************
 * Add page message
 *****************************************************************
 */

function SetPageMessage(string m) {
    Message.Caption = m;
}

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    AddBackButton ();
    AddSelectButton ();
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
    GamerTag = param1;
    Xuid = param2;

    SetPageCaption(GamerTag);
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
 * NotifyLevelChange
 *
 *****************************************************************
 */
event NotifyLevelChange() {
    Controller.CloseMenu(true);
}

/*****************************************************************
 * B Button pressed
 *
 *****************************************************************
 */

function DoButtonB ()
{
    Controller.CloseMenu(true);
}

/*****************************************************************
 * DefaultProperties
 *
 *****************************************************************
 */

defaultproperties
{
     Begin Object Class=GUILabel Name=Message_lbl
         TextFont="XBigFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.100000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.300000
         RenderWeight=0.900000
         Name="Message_lbl"
     End Object
     Message=GUILabel'DOTZMenu.XDOTZLivePlayerBaseIG.Message_lbl'
     RemoveFriendMenu="DOTZMenu.XDOTZLiveRemoveFriend"
     RequestFriendMenu="DOTZMenu.XDOTZLivePlayerRequestVoiceIG"
     RecordVoiceMenu="DOTZMenu.XDOTZRecordingVoiceMail"
     PlayVoiceMenu="DOTZMenu.XDOTZPlayingVoiceMail"
     ClearVoiceMenu="DOTZMenu.XDOTZClearingVoiceMail"
     ClickSound=Sound'DOTZXInterface.Select'
     WinTop=0.200000
     WinLeft=0.150000
     WinWidth=0.700000
     WinHeight=0.600000
}
