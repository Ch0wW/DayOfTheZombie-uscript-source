// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZSPPauseDemo- demo pause page
 *  -ripped from XDOTZSPPause
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #1 $
 * @date    June 21, 2005
 */

class XDOTZSPPauseDemo extends XDOTZInGamePage;



//Page components
var Automated GuiButton  ContinueButton;
var Automated GuiButton  FriendsListButton;
var Automated GuiButton  OfflineButton;
var Automated GuiButton  SaveButton;
var Automated GuiButton  LoadButton;
var Automated GuiButton  QuitButton;

var Automated GUIImage   FriendsRequestNotification;
var Automated GUIImage   FriendsInviteNotification;

//configurable stuff
var string ContinueMenu;              // Single Player menu location
var string FriendsListMenu;           // Xbox Live menu location
var string SaveMenu;
var string LoadMenu;      // System Link menu location
var string QuitMenu;                  // Profile menu location

//configurable stuff
var localized string PageCaption;

var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);

    SetPageCaption (PageCaption);
    AddBackButton ();
    AddSelectButton ();

    // if we are not signed in to live, then hide the friends menu
   // if (!class'UtilsXbox'.static.Is_Signed_In()) {
        // Hide button and move up other two

        SaveButton.WinTop = SaveButton.WinTop - 0.2;
        LoadButton.WinTop = LoadButton.WinTop - 0.2;
        QuitButton.WinTop = QuitButton.WinTop - 0.2;

        RemoveComponent(FriendsListButton, true);
        RemoveComponent(OfflineButton, true);
        MapControls();
        /*
    } else {
        if (class'UtilsXbox'.static.Is_Player_Online_Set()) {
            OfflineButton.Caption = appear_offline_string;
        } else {
            OfflineButton.Caption = appear_online_string;
        }
    }
    */
}


/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

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
        case ContinueButton:
             DoButtonB ();
             return false;
             break;

        case QuitButton:
             return Controller.OpenMenu(QuitMenu);
             break;
    };

   return false;
}

/*****************************************************************
 * Continue if B pressed too
 *
 *****************************************************************
 */

function DoButtonB ()
{
    // Unpause
    Controller.ViewportOwner.Actor.Level.Game
        .SetPause( false, Controller.ViewportOwner.Actor );
    Controller.CloseAll(false);
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
     Begin Object Class=GUIButton Name=ContinueButton_btn
         Caption="Continue"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.100000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSPPauseDemo.ButtonClicked
         Name="ContinueButton_btn"
     End Object
     ContinueButton=GUIButton'DOTZMenu.XDOTZSPPauseDemo.ContinueButton_btn'
     Begin Object Class=GUIButton Name=FriendsListButton_btn
         Caption="Friends List"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.200000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSPPauseDemo.ButtonClicked
         Name="FriendsListButton_btn"
     End Object
     FriendsListButton=GUIButton'DOTZMenu.XDOTZSPPauseDemo.FriendsListButton_btn'
     Begin Object Class=GUIButton Name=OfflineButton_btn
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.300000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSPPauseDemo.ButtonClicked
         Name="OfflineButton_btn"
     End Object
     OfflineButton=GUIButton'DOTZMenu.XDOTZSPPauseDemo.OfflineButton_btn'
     Begin Object Class=GUIButton Name=SaveButton_btn
         Caption="Save Game"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.400000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         Name="SaveButton_btn"
     End Object
     SaveButton=GUIButton'DOTZMenu.XDOTZSPPauseDemo.SaveButton_btn'
     Begin Object Class=GUIButton Name=RevertToLastSaveButton_btn
         Caption="Load Game"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.500000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         Name="RevertToLastSaveButton_btn"
     End Object
     LoadButton=GUIButton'DOTZMenu.XDOTZSPPauseDemo.RevertToLastSaveButton_btn'
     Begin Object Class=GUIButton Name=QuitButton_btn
         Caption="Quit"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=3
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSPPauseDemo.ButtonClicked
         Name="QuitButton_btn"
     End Object
     QuitButton=GUIButton'DOTZMenu.XDOTZSPPauseDemo.QuitButton_btn'
     Begin Object Class=GUIImage Name=FriendsRequestNotification_icn
         Image=Texture'DOTZTInterface.XBoxIcons.FriendRequest'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.200000
         WinLeft=0.350000
         WinWidth=0.080000
         WinHeight=0.080000
         Name="FriendsRequestNotification_icn"
     End Object
     FriendsRequestNotification=GUIImage'DOTZMenu.XDOTZSPPauseDemo.FriendsRequestNotification_icn'
     Begin Object Class=GUIImage Name=FriendsInviteNotification_icn
         Image=Texture'DOTZTInterface.XBoxIcons.Invite'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         bNeverFocus=True
         WinTop=0.200000
         WinLeft=0.350000
         WinWidth=0.080000
         WinHeight=0.080000
         Name="FriendsInviteNotification_icn"
     End Object
     FriendsInviteNotification=GUIImage'DOTZMenu.XDOTZSPPauseDemo.FriendsInviteNotification_icn'
     ContinueMenu="DOTZMenu.XDOTZSPLevelList"
     FriendsListMenu="DOTZMenu.XDOTZLiveFriendsListIG"
     SaveMenu="DOTZMenu.XDOTZSaveMenu"
     LoadMenu="DOTZMenu.XDOTZLoadMenu"
     QuitMenu="DOTZMenu.XDOTZQuitConfirmDemo"
     PageCaption="Paused"
     ClickSound=Sound'DOTZXInterface.Select'
     WinTop=0.250000
     WinHeight=0.500000
     __OnKeyEvent__Delegate=XDOTZSPPauseDemo.HandleKeyEvent
}
