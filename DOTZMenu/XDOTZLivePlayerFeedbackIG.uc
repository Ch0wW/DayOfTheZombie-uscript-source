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

class XDOTZLivePlayerFeedbackIG extends XDOTZLivePlayerBaseIG;




//Page components
var Automated GuiButton     GreatSessionButton;
var Automated GuiButton     GoodAttitudeButton;

var Automated GuiButton     BadNameButton;
var Automated GuiButton     CursingButton;
var Automated GuiButton     ScreamingButton;
var Automated GuiButton     CheatingButton;
var Automated GuiButton     ThreatsButton;

var localized string Message;

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

	/*
    GREAT_SESSION = 0
	GOOD_ATTITUDE = 1
	BAD_NAME = 2
	CURSING = 3
	SCREAMING = 4
	CHEATING = 5
	THREATS = 6
	*/

    switch (Selected) {
        case GreatSessionButton:
             class'UtilsXbox'.static.Friends_Send_Feedback(Gamertag, Xuid, 0);
             BBGuiController(Controller).CloseTo ('XDOTZLivePlayerSelectIG');
             return false;
             break;

        case GoodAttitudeButton:
             class'UtilsXbox'.static.Friends_Send_Feedback(Gamertag, Xuid, 1);
             BBGuiController(Controller).CloseTo ('XDOTZLivePlayerSelectIG');
             return false;
             break;

        case BadNameButton:
             Controller.OpenMenu("DOTZMenu.XDOTZLiveComplaintBadName", Gamertag, Xuid);
             return false;
             break;

        case CursingButton:
             Controller.OpenMenu("DOTZMenu.XDOTZLiveComplaintCursing", Gamertag, Xuid);
             return false;
             break;

        case ScreamingButton:
             Controller.OpenMenu("DOTZMenu.XDOTZLiveComplaintScreaming", Gamertag, Xuid);
             return false;
             break;

        case CheatingButton:
             Controller.OpenMenu("DOTZMenu.XDOTZLiveComplaintCheating", Gamertag, Xuid);
             return false;
             break;

        case ThreatsButton:
             Controller.OpenMenu("DOTZMenu.XDOTZLiveComplaintThreats", Gamertag, Xuid);
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
     Begin Object Class=GUIButton Name=GreatSessionButton_btn
         Caption="Great Session"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.300000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLivePlayerFeedbackIG.ButtonClicked
         Name="GreatSessionButton_btn"
     End Object
     GreatSessionButton=GUIButton'DOTZMenu.XDOTZLivePlayerFeedbackIG.GreatSessionButton_btn'
     Begin Object Class=GUIButton Name=GoodAttitudeButton_btn
         Caption="Good Attitude"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLivePlayerFeedbackIG.ButtonClicked
         Name="GoodAttitudeButton_btn"
     End Object
     GoodAttitudeButton=GUIButton'DOTZMenu.XDOTZLivePlayerFeedbackIG.GoodAttitudeButton_btn'
     Begin Object Class=GUIButton Name=BadNameButton_btn
         Caption="Bad Name"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.300000
         WinLeft=0.500000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLivePlayerFeedbackIG.ButtonClicked
         Name="BadNameButton_btn"
     End Object
     BadNameButton=GUIButton'DOTZMenu.XDOTZLivePlayerFeedbackIG.BadNameButton_btn'
     Begin Object Class=GUIButton Name=CursingButton_btn
         Caption="Cursing or Lewdness"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.700000
         WinLeft=0.500000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLivePlayerFeedbackIG.ButtonClicked
         Name="CursingButton_btn"
     End Object
     CursingButton=GUIButton'DOTZMenu.XDOTZLivePlayerFeedbackIG.CursingButton_btn'
     Begin Object Class=GUIButton Name=ScreamingButton_btn
         Caption="Screaming"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.500000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLivePlayerFeedbackIG.ButtonClicked
         Name="ScreamingButton_btn"
     End Object
     ScreamingButton=GUIButton'DOTZMenu.XDOTZLivePlayerFeedbackIG.ScreamingButton_btn'
     Begin Object Class=GUIButton Name=CheatingButton_btn
         Caption="Cheating"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.500000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLivePlayerFeedbackIG.ButtonClicked
         Name="CheatingButton_btn"
     End Object
     CheatingButton=GUIButton'DOTZMenu.XDOTZLivePlayerFeedbackIG.CheatingButton_btn'
     Begin Object Class=GUIButton Name=ThreatsButton_btn
         Caption="Threats or Harassment"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.500000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZLivePlayerFeedbackIG.ButtonClicked
         Name="ThreatsButton_btn"
     End Object
     ThreatsButton=GUIButton'DOTZMenu.XDOTZLivePlayerFeedbackIG.ThreatsButton_btn'
     Message="Feedback for"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLivePlayerFeedbackIG.HandleKeyEvent
}
