// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZLiveMultiplayer
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #7 $
 * @date    January 19, 2005
 */

class XDOTZSPMainMenu extends XDOTZSinglePlayerBase;



struct CheatSeq{
   var Array<int> cmd;
   var int pos;
};

var Array<CheatSeq> Cheats;
var localized string LevelNameTxt;

//Page components
var Automated GuiButton  NewGameButton;
var Automated GuiButton  LoadGameButton;
var Automated GuiButton  DebugButton;

//configurable stuff
var string LoadMenu;
var string DebugMenu;

//configurable stuff
var localized string PageCaption;


var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner )
{
   Super.Initcomponent(MyController, MyOwner);
   // init my components...
   RemoveComponent(DebugButton, true);
   MapControls();

   SetPageCaption (PageCaption);
   AddBackButton ();
   AddSelectButton ();
}



/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
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
        case NewGameButton:
            class'UtilsXbox'.static.Set_Reboot_Type(5);   // Is single player

             // Display loading screen
             Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu",LevelNameTxt);

             PlayerOwner().Level.ServerTravel("Level-01.day",false);
             break;

        case LoadGameButton:
             return Controller.OpenMenu(LoadMenu,"false");
             break;

        case DebugButton:
             return Controller.OpenMenu(DebugMenu);
             break;

    };

   return false;
}

/*****************************************************************
 * B Button pressed
 *****************************************************************
 */

function DoButtonB ()
{
    Controller.CloseMenu(true);
}

/*****************************************************************
 * NotifyLevelChange
 *****************************************************************
 */

event NotifyLevelChange()
{
    Controller.CloseMenu(true);
}

function bool HandleKeyEvent(out byte Key,out byte State,float delta) {
   //only check the button down
   if (State== 1){
      ProcessInput(Key);
   }
   return super.HandleKeyEvent(Key,State,delta);
}

/*****************************************************************
 * You can look at the actual keys that were pressed if you co-ordinate
 * with your controller class and call the function right. Rereading this
 * comment, I have written something pretty useless. Great!
//A     = 200
//B     = 201
//X     = 202
//UP    = 208
//DOWN  = 209
//LEFT  = 210
//RIGHT = 211
 *****************************************************************
 */
function ProcessInput(int Key){

   local int i;
   local int SearchKey;

   for (i=0;i<Cheats.length;++i){
      SearchKey = Cheats[i].cmd[Cheats[i].pos];
      if ( SearchKey == Key){
         Cheats[i].pos++;
         Log("part of a cheat detected");
         if (Cheats[i].pos == Cheats[i].cmd.length){
            DoCheat(i);
            Cheats[i].pos = 0;
         }
      } else {
        Cheats[i].pos = 0;
      }
   }

}

/*****************************************************************
 * DoCheat
 *****************************************************************
 */
function DoCheat(int CheatNumber){
   Log("The debug button should be visible");
   InsertComponent(DebugButton,0);
   MapControls();
}


/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     Cheats(0)=(Cmd=(202,208,211,208,211))
     LevelNameTxt="Chapter 1"
     Begin Object Class=GUIButton Name=NewGameButton_btn
         Caption="New Game"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.370000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSPMainMenu.ButtonClicked
         Name="NewGameButton_btn"
     End Object
     NewGameButton=GUIButton'DOTZMenu.XDOTZSPMainMenu.NewGameButton_btn'
     Begin Object Class=GUIButton Name=LoadGameButton_btn
         Caption="Load Game"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.470000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSPMainMenu.ButtonClicked
         Name="LoadGameButton_btn"
     End Object
     LoadGameButton=GUIButton'DOTZMenu.XDOTZSPMainMenu.LoadGameButton_btn'
     Begin Object Class=GUIButton Name=DebugButton_btn
         Caption="All Levels"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.570000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSPMainMenu.ButtonClicked
         Name="DebugButton_btn"
     End Object
     DebugButton=GUIButton'DOTZMenu.XDOTZSPMainMenu.DebugButton_btn'
     LoadMenu="DOTZMenu.XDOTZLoadMenuCheckpoint"
     DebugMenu="DOTZMenu.XDOTZSPLevelList"
     PageCaption="Single Player"
     ClickSound=Sound'DOTZXInterface.Select'
     __OnKeyEvent__Delegate=XDOTZSPMainMenu.HandleKeyEvent
}
