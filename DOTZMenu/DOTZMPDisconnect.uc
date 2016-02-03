// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZMainMenu - the main menu for Xbox DOTZ, based on the Warfare
 *              "GUI" package.
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #2 $
 * @date    January 19, 2005
 */

class DOTZMPDisconnect extends DOTZInGamePage;



//Page components
var Automated GuiButton  QuitButton;
//var Automated GuiButton  PlayersListButton;
var Automated GUILabel   ErrorMessage;        // The error message to be displayed


//configurable stuff
var string PlayersListMenu;           // Xbox Live menu location
var string QuitMenu;                  // Profile menu location

//configurable stuff
var localized string PageCaption;
var localized string FailedCaption;

var int tickcount;

var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);

    SetPageCaption (PageCaption);

    Log("DOTZMPDisconnect InitComponent Called");
}


/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    // CARROT HACK!!!!
    SetFocus(QuitButton);
    QuitButton.SetFocus(none);
}

/*****************************************************************
 * HandleParameters
 * When open menu get's called, the parameter values are supplied
 * here.
 *
 * Param1 - Alternate text
 *****************************************************************
 */
event HandleParameters( String param1, String param2 ) {

    if (param1 != "")
        SetPageCaption (param1);
}


/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled) {
   Super.Closed(Sender,bCancelled);
   Controller.MouseEmulation(false);

   Log("DOTZMPDisconnect Closed Called");
}

/*****************************************************************
 * HandleKeyEven
 * Intercepts A and B presses
 *****************************************************************
 */

function bool HandleKeyEvent(out byte Key,out byte State,float delta) {
    return true;
}

/*****************************************************************
 *****************************************************************
 */

function Periodic ()
{
    super.Periodic();

    ++tickcount;
    if (tickcount >= 30) {
        ErrorMessage.Caption = FailedCaption;
    }
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

    Log("DOTZMPDisconnect ButtonClicked Called");

    switch (Selected) {
        //case PlayersListButton:
        //     return Controller.OpenMenu(PlayersListMenu);
        //     break;

        case QuitButton:
             Controller.OpenMenu("DOTZMenu.DOTZLoadingMenu");
             PlayerOwner().Level.ServerTravel("MainMenu.day",false);
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
     Begin Object Class=GUIButton Name=QuitButton_btn
         Caption="Quit"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.325000
         WinWidth=0.350000
         WinHeight=0.080000
         TabOrder=3
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMPDisconnect.ButtonClicked
         Name="QuitButton_btn"
     End Object
     QuitButton=GUIButton'DOTZMenu.DOTZMPDisconnect.QuitButton_btn'
     Begin Object Class=GUILabel Name=ErrorMessage_lbl
         Caption="The host is not ready. Trying to reconnect..."
         TextFont="BigGuiFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.100000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.800000
         RenderWeight=0.900000
         Name="ErrorMessage_lbl"
     End Object
     ErrorMessage=GUILabel'DOTZMenu.DOTZMPDisconnect.ErrorMessage_lbl'
     PlayersListMenu="DOTZMenu.DOTZPlayersListIG"
     QuitMenu="DOTZMenu.XDOTZSPLevelList"
     FailedCaption="This game session is no longer available."
     ClickSound=Sound'DOTZXInterface.Select'
     WinTop=0.250000
     WinHeight=0.500000
     __OnKeyEvent__Delegate=DOTZMPDisconnect.HandleKeyEvent
}
