// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    Sept 2003
 */
class DOTZSaveConfirm extends DOTZErrorPage;

var string OldSaveName;
var string Owner;

var localized string SaveMessage;
var localized string SaveMessageOver;
var localized string save_string;

var automated GUIButton YesButton;
var automated GUIButton NoButton;

/*****************************************************************
 * Opened
 *****************************************************************
 */
event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);
}


/*****************************************************************
 * HandleParameters
 * When open menu get's called, the parameter values are supplied here.
 *****************************************************************
 */
event HandleParameters( String param1, String param2 ) {
    OldSaveName = param1;
    Owner = param2;

    if (OldSaveName == "") {
        SetErrorCaption(SaveMessage);
    } else {
        SetErrorCaption(SaveMessageOver);
    }
}

/*****************************************************************
 * InternalOnClick
 *****************************************************************
 */

function bool InternalOnClick(GUIComponent Sender) {
    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
    if ( Sender == YesButton ) {

        PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
        AdvancedGameInfo(PlayerOwner().Level.Game).SaveOverGame(OldSaveName, Owner, 0);

        //the save slot protects itself so that nothing can happen until the
        //next tick. However there is no next tick if you are paused (as you are now)
        //so if you want to save to another slot, then you need to reset the save
        //var manually
        AdvancedGameInfo(PlayerOwner().Level.Game).bSaveInProgress = false;
        BBGUIController(Controller).CloseTo('DOTZSPPause');
    } else {
        Controller.CloseMenu(false);
    }
    return true;
}

//===========================================================================
// defaultproperties
//===========================================================================

defaultproperties
{
     SaveMessage="Save your progress?"
     SaveMessageOver="Are you sure you want to overwrite this game?"
     save_string="Save"
     Begin Object Class=GUIButton Name=cYesButton
         Caption="Save"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.600000
         WinWidth=0.250000
         WinHeight=0.200000
         __OnClick__Delegate=DOTZSaveConfirm.InternalOnClick
         Name="cYesButton"
     End Object
     YesButton=GUIButton'DOTZMenu.DOTZSaveConfirm.cYesButton'
     Begin Object Class=GUIButton Name=cNoButton
         Caption="Cancel"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.200000
         WinWidth=0.250000
         WinHeight=0.200000
         TabOrder=1
         __OnClick__Delegate=DOTZSaveConfirm.InternalOnClick
         Name="cNoButton"
     End Object
     NoButton=GUIButton'DOTZMenu.DOTZSaveConfirm.cNoButton'
     WinHeight=0.250000
     __OnKeyEvent__Delegate=DOTZSaveConfirm.HandleKeyEvent
}
