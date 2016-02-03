//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DOTZExitMenuDemo extends DOTZDemo;



var Automated GuiButton  QuitButton;
//var bool accept_input;
//var float period;
var int Counter;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */
function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);
    // init my components...
    //SetTimer(5,false);
//    period = 5;
  //  accept_input = false;
   Counter = 0;
}

/*****************************************************************
 * Timer
 *****************************************************************
*/
function Periodic()
{
   Counter++;
   if (Counter > 10){
      PlayerOwner().ConsoleCommand( "exit" );
   }
}

/*****************************************************************
 * InternalOnClick
 *****************************************************************
 */

function bool ButtonClicked(GUIComponent Sender) {
   PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
   PlayerOwner().ConsoleCommand( "exit" );
   return true;
}

defaultproperties
{
     Begin Object Class=GUIButton Name=QuitButton_btn
         Caption="Quit"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         Hint="Exit the game."
         WinTop=0.870000
         WinLeft=0.600000
         WinWidth=0.500000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=DOTZExitMenuDemo.ButtonClicked
         Name="QuitButton_btn"
     End Object
     QuitButton=GUIButton'DOTZMenu.DOTZExitMenuDemo.QuitButton_btn'
     Background=Texture'DOTZTInterface.Demo.BoilerPlate'
     __OnKeyEvent__Delegate=DOTZExitMenuDemo.HandleKeyEvent
}
