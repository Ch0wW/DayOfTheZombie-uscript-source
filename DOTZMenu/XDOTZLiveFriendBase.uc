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

class XDOTZLiveFriendBase extends XDOTZLiveFriendsListBase;




//Page components
var Automated GUILabel   Message;

//configurable stuff
var string RemoveFriendMenu;    // Single Player menu location
var string PlayVoiceMenu;

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
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);
}


/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
    local string gamer_tag;

    super.Opened(Sender);

    gamer_tag = class'UtilsXbox'.static.Friends_Get_Gamer_Tag();
    SetPageCaption(gamer_tag);

    AddBackButton ();
    AddSelectButton ();
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
         TextFont="XPlainMedFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.300000
         WinLeft=0.200000
         WinWidth=0.600000
         WinHeight=0.300000
         RenderWeight=0.900000
         Name="Message_lbl"
     End Object
     Message=GUILabel'DOTZMenu.XDOTZLiveFriendBase.Message_lbl'
     RemoveFriendMenu="DOTZMenu.XDOTZLiveRemoveFriend"
     PlayVoiceMenu="DOTZMenu.XDOTZPlayingVoiceMail"
     ClickSound=Sound'DOTZXInterface.Select'
}
