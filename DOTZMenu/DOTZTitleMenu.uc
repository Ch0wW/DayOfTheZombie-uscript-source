// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 *
 * @author  jlachapelle
 * @version $Revision: #5 $
 * @date    Sept 2003
 */
class DOTZTitleMenu extends DOTZPageBase;



var Automated GUILabel MainTitleText;
var Automated GUILabel SmallText;
var Automated GUILabel SmallText2;
var float TimeRemaining;

 /*****************************************************************
  * InitComponent
  *****************************************************************
 */
function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
   Super.Initcomponent(MyController, MyOwner);
    Log(self $ "InitComponent");
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

    local string text1, text2;
    local int i;

    if (param1 != ""){
        MainTitleText.Caption = param1;
    }

    if (param2 != ""){
        i = InStr(param2,"|");
        if (i >0){
            text1 = Left(param2,i);
            text2 = Right(param2,Len(param2)- i-1);
        } else {
            text1 = param2;
            text2= "";
        }

        SmallText.Caption = text1;
        SmallText2.Caption = text2;
    }
}

/*****************************************************************
 * Opened
 *****************************************************************
 */
event Opened( GUIComponent Sender ) {
   local AdvancedPlayerController pc;

   pc = AdvancedPlayerController(PlayerOwner());
   pc.ClientFlash(0,vect(0,0,0));
   pc.bClearScreen=true;
   pc.StopAllMusic(0.1);
   pc.ConsoleCommand("StopSounds");
//   pc.ConsoleCommand( "PauseSounds");
   pc.bNoPauseMenu = true;
   pc.Level.Game.SetPause(true,pc);
   pc.bNoPauseMenu = false;
   super.opened(Sender);
}

/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled) {
   Super.Closed(Sender,bCancelled);
    Log(self $ "Closed");
}

/*****************************************************************
 * HandleKeyEven
 * It was like this when I got here
 *****************************************************************
 */
function bool HandleKeyEvent(out byte Key,out byte State,float delta) {
    //@@@ need to do something about the button-skipping problem here?
     if (Key == 27) {  //Esc
//        Controller.CloseMenu(true);
    }
   return true;
}

/*****************************************************************
 * NotifyLevelChange
 *****************************************************************
 */
event NotifyLevelChange() {
   Controller.CloseMenu(true);
}

/*****************************************************************
 * Periodic
 *****************************************************************
 */
function Periodic()
{
    local AdvancedPlayerController pc;
    TimeRemaining -= 0.5;
    if (TimeRemaining <= 0)
    {
        pc = AdvancedPlayerController(PlayerOwner());
        pc.bClearScreen=false;
  //      pc.ConsoleCommand( "UnPauseSounds");
        pc.Level.Game.SetPause(false,pc);
        pc.PlayMusic(pc.Song,0.1);
        Controller.CloseMenu(true);
    }
}
//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     Begin Object Class=GUILabel Name=Loading_control
         Caption="Title"
         TextAlign=TXTA_Center
         TextFont="BigGuiFont"
         WinTop=0.080000
         WinHeight=0.400000
         RenderWeight=0.900000
         Name="Loading_control"
     End Object
     MainTitleText=GUILabel'DOTZMenu.DOTZTitleMenu.Loading_control'
     Begin Object Class=GUILabel Name=Fact_control
         TextFont="PlainMedGuiFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.150000
         WinWidth=0.700000
         WinHeight=0.750000
         RenderWeight=0.900000
         Name="Fact_control"
     End Object
     SmallText=GUILabel'DOTZMenu.DOTZTitleMenu.Fact_control'
     Begin Object Class=GUILabel Name=Fact_control2
         TextFont="PlainMedGuiFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.550000
         WinLeft=0.150000
         WinWidth=0.700000
         WinHeight=0.750000
         RenderWeight=0.900000
         Name="Fact_control2"
     End Object
     SmallText2=GUILabel'DOTZMenu.DOTZTitleMenu.Fact_control2'
     TimeRemaining=5.000000
     Background=Texture'Engine.ConsoleBK'
     bAllowedAsLast=True
     WinHeight=0.870000
     __OnKeyEvent__Delegate=DOTZTitleMenu.HandleKeyEvent
}
