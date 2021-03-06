// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DOTZProfileForceSelect extends DOTZErrorPage;

var sound ClickSound;

// Error string
var localized string error_string;
var automated GUIButton BackButton;

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
    if ( Sender == BackButton ) {
        Controller.CloseMenu(true);
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
     error_string="You must select a profile before you can continue."
     Begin Object Class=GUIButton Name=cBackButton
         Caption="Back"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.375000
         WinWidth=0.250000
         WinHeight=0.200000
         __OnClick__Delegate=DOTZProfileForceSelect.InternalOnClick
         Name="cBackButton"
     End Object
     BackButton=GUIButton'DOTZMenu.DOTZProfileForceSelect.cBackButton'
     WinHeight=0.250000
     __OnKeyEvent__Delegate=DOTZProfileForceSelect.HandleKeyEvent
}
