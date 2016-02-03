// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZLivePlayerVoiceMailOptionIG extends XDOTZLivePlayerBaseIG;



var sound ClickSound;

var Automated GuiButton  Yes_Button;
var Automated GuiButton  No_Button;

var localized string Message;

/*****************************************************************
 * Opened
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);

   SetPageMessage(Message);
}

/*****************************************************************
 * Button B pressed
 *****************************************************************
 */

function DoButtonB ()
{
    Controller.CloseMenu(true);
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
        case Yes_Button:
            BBGuiController(Controller).SwitchMenu("DOTZMenu.XDOTZLivePlayerRequestVoiceIG",Gamertag,Xuid);
            return false; break;

        case No_Button:
            class'UtilsXbox'.static.Friends_Send_Friend_Request_With_Voice(Xuid);
            Controller.CloseMenu(true);
            return false; break;
    };

   return false;
}

/*****************************************************************
 * default properties
 *****************************************************************
 */

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     Begin Object Class=GUIButton Name=Yes_Button_btn
         Caption="Yes"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLivePlayerVoiceMailOptionIG.ButtonClicked
         Name="Yes_Button_btn"
     End Object
     Yes_Button=GUIButton'DOTZMenu.XDOTZLivePlayerVoiceMailOptionIG.Yes_Button_btn'
     Begin Object Class=GUIButton Name=No_Button_btn
         Caption="No"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLivePlayerVoiceMailOptionIG.ButtonClicked
         Name="No_Button_btn"
     End Object
     No_Button=GUIButton'DOTZMenu.XDOTZLivePlayerVoiceMailOptionIG.No_Button_btn'
     Message="Do you want to send a voice mail attachment?"
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLivePlayerVoiceMailOptionIG.HandleKeyEvent
}
