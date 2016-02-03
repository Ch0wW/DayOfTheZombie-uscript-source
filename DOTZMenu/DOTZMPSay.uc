// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class DOTZMPSay extends DOTZInGamePage;

var localized string PageCaption;

var automated GUIButton YesButton;
var automated GUIButton NoButton;
var Automated GUILabel  ErrorMessage;        // The error message to be displayed
var Automated BBEditBox MsgBox;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner){
    Super.InitComponent(Mycontroller, MyOwner);
   SetPageCaption(PageCaption);
   SetTimer(0.5,false);
}


function Timer(){
   super.Timer();
   SetFocus(MsgBox);
   MsgBox.SetFocus(self);
}

/*****************************************************************
 * CancelClicked
 *****************************************************************
 */
function bool CancelClicked(GUIComponent Sender){
    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
    Controller.CloseMenu(false);
    return true;
}

/*****************************************************************
 * LoadClicked
 *****************************************************************
 */
function bool LoadClicked(GUIComponent Sender){
    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
    PlayerOwner().Say(MsgBox.GetText());
    Controller.CloseMenu(false);
    return true;
}

/*****************************************************************
 * HandleKeyEven
 * Intercepts A and B presses
 *****************************************************************
 */

function bool HandleKeyEvent(out byte Key,out byte State,float delta) {
  if (Key == 13){ //Enter
     LoadClicked(None);
  } else if (Key == 27){  //Esc
     CancelClicked(None);
  }
  return true;
}

defaultproperties
{
     PageCaption="Broadcast"
     Begin Object Class=GUIButton Name=cYesButton
         Caption="OK"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.650000
         WinWidth=0.200000
         WinHeight=0.150000
         __OnClick__Delegate=DOTZMPSay.LoadClicked
         Name="cYesButton"
     End Object
     YesButton=GUIButton'DOTZMenu.DOTZMPSay.cYesButton'
     Begin Object Class=GUIButton Name=cNoButton
         Caption="Cancel"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.300000
         WinWidth=0.200000
         WinHeight=0.150000
         TabOrder=1
         __OnClick__Delegate=DOTZMPSay.CancelClicked
         Name="cNoButton"
     End Object
     NoButton=GUIButton'DOTZMenu.DOTZMPSay.cNoButton'
     Begin Object Class=GUILabel Name=ErrorMessage_lbl
         Caption="Enter message:"
         TextFont="PlainSmGuiFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.220000
         WinLeft=0.100000
         WinWidth=0.600000
         WinHeight=0.800000
         RenderWeight=0.900000
         Name="ErrorMessage_lbl"
     End Object
     ErrorMessage=GUILabel'DOTZMenu.DOTZMPSay.ErrorMessage_lbl'
     Begin Object Class=BBEditBox Name=GetMsg
         MaxWidth=45
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.200000
         WinLeft=0.270000
         WinWidth=0.600000
         WinHeight=0.150000
         Name="GetMsg"
     End Object
     MsgBox=BBEditBox'DOTZMenu.DOTZMPSay.GetMsg'
     WinTop=0.250000
     WinLeft=0.150000
     WinWidth=0.700000
     WinHeight=0.200000
     __OnKeyEvent__Delegate=DOTZMPSay.HandleKeyEvent
}
