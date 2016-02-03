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

class XDOTZLiveFriendSentInvIG extends XDOTZLiveFriendBaseIG;




//Page components
var Automated GuiButton  CancelInvite;
var Automated GuiButton  RemoveFriend;

var localized string Message;

var sound ClickSound;

/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    SetPageMessage(Message);

    // if we are not signed in a multiplayer game, hide the invite stuff
    if (class'UtilsXbox'.static.Get_Reboot_Type() == 5) {      // 5 is single player game
        // Hide button and move up other two
        RemoveFriend.WinTop = RemoveFriend.WinTop - 0.1;

        RemoveComponent(CancelInvite, true);
        MapControls();
    }
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
        case CancelInvite:
             Controller.OpenMenu("DOTZMenu.XDOTZLiveCancelInvIG");
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
     Begin Object Class=GUIButton Name=CancelInvite_btn
         Caption="Cancel Invite"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendSentInvIG.ButtonClicked
         Name="CancelInvite_btn"
     End Object
     CancelInvite=GUIButton'DOTZMenu.XDOTZLiveFriendSentInvIG.CancelInvite_btn'
     Begin Object Class=GUIButton Name=RemoveFriend_btn
         Caption="Remove Friend"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLiveFriendSentInvIG.ButtonClicked
         Name="RemoveFriend_btn"
     End Object
     RemoveFriend=GUIButton'DOTZMenu.XDOTZLiveFriendSentInvIG.RemoveFriend_btn'
     Message="What do you want to do with this friend?"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLiveFriendSentInvIG.HandleKeyEvent
}
