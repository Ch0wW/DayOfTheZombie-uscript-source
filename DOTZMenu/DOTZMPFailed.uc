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

class DOTZMPFailed extends DOTZInGamePage;



//Page components
var Automated GuiButton  QuitButton;
//var Automated GuiButton  PlayersListButton;
var Automated GUILabel   ErrorMessage;        // The error message to be displayed


//configurable stuff
var string PlayersListMenu;           // Xbox Live menu location
var string QuitMenu;                  // Profile menu location

var string LastURL;

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

    Log("DOTZMPFailed InitComponent Called");
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
    ErrorMessage.Caption = param1;

    Log("param1" @ param1);
    Log("default" @  class'AccessControl'.default.NeedPassword);

    if (param1 == class'AccessControl'.default.NeedPassword ||
        param1 == class'AccessControl'.default.WrongPassword) {
        Log("Show prompt for password");

        BBGuiController(Controller).SwitchMenu("DOTZMenu.DOTZGetPassword", default.LastURL);
    }

    //if (ErrorMessage.Caption == "You need to enter a password to join this game."){
//      BBGuiController(Controller).SwitchMenu("DOTZMenu.DOTZGetPassword",);
  //  }
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
 * HandleKeyEven
 * Intercepts A and B presses
 *****************************************************************
 */

function bool HandleKeyEvent(out byte Key,out byte State,float delta) {
    return true;
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

    Log("DOTZMPFailed ButtonClicked Called");

    switch (Selected) {
        //case PlayersListButton:
        //     return Controller.OpenMenu(PlayersListMenu);
        //     break;

         case QuitButton:
            Controller.OpenMenu("DOTZMenu.DOTZLoadingMenu");
            //PlayerOwner().ConsoleCommand("Disconnect");
            PlayerOwner().ConsoleCommand("start MainMenu.day");
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
         WinTop=0.400000
         WinLeft=0.325000
         WinWidth=0.350000
         WinHeight=0.080000
         TabOrder=3
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZMPFailed.ButtonClicked
         Name="QuitButton_btn"
     End Object
     QuitButton=GUIButton'DOTZMenu.DOTZMPFailed.QuitButton_btn'
     Begin Object Class=GUILabel Name=ErrorMessage_lbl
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
     ErrorMessage=GUILabel'DOTZMenu.DOTZMPFailed.ErrorMessage_lbl'
     PlayersListMenu="DOTZMenu.DOTZPlayersListIG"
     QuitMenu="DOTZMenu.XDOTZSPLevelList"
     ClickSound=Sound'DOTZXInterface.Select'
     WinTop=0.250000
     WinHeight=0.500000
     __OnKeyEvent__Delegate=DOTZMPFailed.HandleKeyEvent
}
