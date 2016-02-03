// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    Sept 2003
 */
class XDOTZSaveConfirm extends XDOTZErrorPage;

var string OldSaveName;
var string Owner;

var localized string SaveMessage;
var localized string SaveMessageOver;
var localized string save_string;

/*****************************************************************
 * Opened
 *****************************************************************
 */
event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);
  AddBackButton(cancel_string);
  AddSelectButton(save_string);
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
 * DoButtonA
 *****************************************************************
 */
function DoButtonA(){
    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
    Controller.OpenMenu("DOTZMenu.XDOTZSaving");
    AdvancedGameInfo(PlayerOwner().Level.Game).SaveOverGame(OldSaveName, Owner, 0);

    //the save slot protects itself so that nothing can happen until the
    //next tick. However there is no next tick if you are paused (as you are now)
    //so if you want to save to another slot, then you need to reset the save
    //var manually
    AdvancedGameInfo(PlayerOwner().Level.Game).bSaveInProgress = false;

}

/*****************************************************************
 * DoButtonB
 *****************************************************************
 */
function DoButtonB(){
   Controller.CloseMenu(false);
}


//===========================================================================
// defaultproperties
//===========================================================================

defaultproperties
{
     SaveMessage="Save your progress?"
     SaveMessageOver="Are you sure you want to overwrite this game?"
     save_string="Save"
     __OnKeyEvent__Delegate=XDOTZSaveConfirm.HandleKeyEvent
}
