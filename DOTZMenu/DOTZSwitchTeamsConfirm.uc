// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DOTZSwitchTeamsConfirm extends DOTZErrorPage;

var sound ClickSound;

// Error string
var localized string error_string;

// Profiles
//var Profiler profiles;

var automated GUIButton YesButton;
var automated GUIButton NoButton;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
   Super.Initcomponent(MyController, MyOwner);
}

/*****************************************************************
 * Opened
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);

   SetErrorCaption(error_string);
}

/*****************************************************************
 * InternalOnClick
 *****************************************************************
 */

function bool InternalOnClick(GUIComponent Sender) {
    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
    if ( Sender == YesButton ) {
        PlayerOwner().SwitchTeam();
        Controller.CloseMenu(true);
    } else {
        Controller.CloseMenu(false);
    }
    return true;
}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     error_string="Do you really want to switch teams?"
     Begin Object Class=GUIButton Name=cYesButton
         Caption="Yes"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.600000
         WinWidth=0.250000
         WinHeight=0.200000
         __OnClick__Delegate=DOTZSwitchTeamsConfirm.InternalOnClick
         Name="cYesButton"
     End Object
     YesButton=GUIButton'DOTZMenu.DOTZSwitchTeamsConfirm.cYesButton'
     Begin Object Class=GUIButton Name=cNoButton
         Caption="No"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.200000
         WinWidth=0.250000
         WinHeight=0.200000
         TabOrder=1
         __OnClick__Delegate=DOTZSwitchTeamsConfirm.InternalOnClick
         Name="cNoButton"
     End Object
     NoButton=GUIButton'DOTZMenu.DOTZSwitchTeamsConfirm.cNoButton'
     WinHeight=0.250000
     __OnKeyEvent__Delegate=DOTZSwitchTeamsConfirm.HandleKeyEvent
}
