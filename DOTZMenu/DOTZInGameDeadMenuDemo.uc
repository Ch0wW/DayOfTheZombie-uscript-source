/**
 * XDOTZMainMenu - the main menu for Xbox DOTZ, based on the Warfare
 *              "GUI" package.
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class DOTZInGameDeadMenuDemo extends DOTZInGamePage;



//Page components
var Automated GuiButton  ContinueButton;
var Automated GuiButton  LoadButton;
var Automated GuiButton  SaveButton;
var Automated GuiButton  OptionsButton;
var Automated GuiButton  QuitButton;

//configurable stuff
var string ContinueMenu;              // Single Player menu location
var string LoadMenu;
var string SaveMenu;
var string OptionsMenu;      // System Link menu location
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
}


/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

     // Add a delay before accepting input
    accept_input = false;
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
//        case ContinueButton:
  //           Controller.ViewportOwner.Actor.SetPause(false);
    //         return Controller.CloseMenu(true);
      //       break;

//        case LoadButton:
//             return Controller.OpenMenu(LoadMenu);
//             break;

//        case SaveButton:
//             return Controller.OpenMenu(SaveMenu);
//             break;

        //case LoadButton:
             //return Controller.OpenMenu(LoadMenu,"true");
             //break;

        case OptionsButton:
             return Controller.OpenMenu(OptionsMenu);
             break;

        case QuitButton:
             return Controller.OpenMenu(QuitMenu);
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
    //Controller.CloseMenu(true);
}

//===========================================================================
// DefaultProperties
//===========================================================================















/*****************************************************************
 * ButtonCllicked
 *****************************************************************

function bool ButtonClicked(GUIComponent Sender) {
   local GUIButton Selected;


      //NEW GAME BUTTON
        case NewGameButton:
           Console(Controller.Master.Console).ConsoleCommand( NewGameLevel );
           Controller.CloseAll(false);
           return true;

      //RESUME GAME BUTTON
      case ResumeGameButton:
         Controller.ViewportOwner.Actor.Level.Game
            .SetPause( false, Controller.ViewportOwner.Actor );
         Controller.CloseAll( false );
          return true;

      //SETTINGS BUTTON
      case SettingsButton:
           return Controller.OpenMenu(SettingsMenu);

      //QUIT BUTTON
      case QuitButton:
            return Controller.OpenMenu(QuitConfirm);

   }
   return false;
}


 */

defaultproperties
{
     Begin Object Class=GUIButton Name=OptionsButton_btn
         Caption="Settings"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.200000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.099900
         TabOrder=3
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZInGameDeadMenuDemo.ButtonClicked
         Name="OptionsButton_btn"
     End Object
     OptionsButton=GUIButton'DOTZMenu.DOTZInGameDeadMenuDemo.OptionsButton_btn'
     Begin Object Class=GUIButton Name=QuitButton_btn
         Caption="Quit"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.300000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.099900
         TabOrder=4
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZInGameDeadMenuDemo.ButtonClicked
         Name="QuitButton_btn"
     End Object
     QuitButton=GUIButton'DOTZMenu.DOTZInGameDeadMenuDemo.QuitButton_btn'
     ContinueMenu="DOTZMenu.DOTZSPLevelList"
     OptionsMenu="DOTZMenu.DOTZSettingsMenuIG"
     QuitMenu="DOTZMenu.DOTZQuitGameConfirm"
     PageCaption="Paused"
     ClickSound=Sound'DOTZXInterface.Select'
     period=0.100000
     WinTop=0.250000
     WinLeft=0.250000
     WinWidth=0.500000
     WinHeight=0.500000
     __OnKeyEvent__Delegate=DOTZInGameDeadMenuDemo.HandleKeyEvent
}
