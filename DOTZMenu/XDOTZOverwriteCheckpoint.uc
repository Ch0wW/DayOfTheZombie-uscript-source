// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZOverwriteCheckpoint : ask user if they want to overwrite a checkpoitn
 *
 * @author  Seelan V. (seelan@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    July 2005
 */
class XDOTZOverwriteCheckpoint extends XDOTZErrorPage;


var localized string SaveMessageOver1;
var localized string SaveMessageOver2;
var localized string save_string;

var string mapname;

var Automated GUILabel   ErrorMessage2;        // The error message to be displayed
var Automated GUILabel   ErrorMessage3;        // The error message to be displayed


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
    //local string tmp;

    mapname = param1;
    //tmp = "Checkpoint" @ PlayerOwner().Level.ActiveCheckPointID @ "-" @ GameSpecificLevelInfo(PlayerOwner().Level.GameSpecificLevelInfo).LevelName;
    SetErrorCaption( mapname );

    SetErrorCaption( SaveMessageOver1 );
    ErrorMessage2.Caption = mapname $ ".";
    ErrorMessage3.Caption = SaveMessageOver2;

    //You have reached Checkpoint 1 – The farm. This is a previously saved checkpoint.  Would you like to overwrite it? Existing information will be lost
    //tmp = SaveMessageOver1 @ mapname $ SaveMessageOver2;
    //ErrorMessage2.Caption =  SaveMessageOver;
    //SetErrorCaption( tmp );
}


/*****************************************************************
 * DoButtonA
 *****************************************************************
 */
function DoButtonA(){
    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
    Controller.OpenMenu("DOTZMenu.XDOTZSaving");

    //AdvancedHud(Level.GetLocalPlayerController().myHud).Message(Level.GetLocalPlayerController().PlayerReplicationInfo, SaveMessage, 'INFO');
    Controller.ConsoleCommand( "SaveCheckPoint \"" $ mapname $ "\"");

    //the save slot protects itself so that nothing can happen until the
    //next tick. However there is no next tick if you are paused (as you are now)
    //so if you want to save to another slot, then you need to reset the save
    //var manually
    //AdvancedGameInfo(PlayerOwner().Level.Game).bSaveInProgress = false;

}

/*****************************************************************
 * DoButtonB
 *****************************************************************
 */
function DoButtonB(){
   //Controller.CloseMenu(false);
   //Controller.CloseAll(false);

   Controller.ViewportOwner.Actor.Level.Game
        .SetPause( false, Controller.ViewportOwner.Actor );
    BBGuiController(Controller).CloseAll( false );
}






//===========================================================================
// defaultproperties
//===========================================================================

defaultproperties
{
     SaveMessageOver1="You have reached"
     SaveMessageOver2="This is a previously saved checkpoint.  Would you like to overwrite it? Existing information will be lost."
     save_string="Save"
     Begin Object Class=GUILabel Name=ErrorMessage2_lbl
         TextFont="XBigFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.200000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.800000
         RenderWeight=0.900000
         Name="ErrorMessage2_lbl"
     End Object
     ErrorMessage2=GUILabel'DOTZMenu.XDOTZOverwriteCheckpoint.ErrorMessage2_lbl'
     Begin Object Class=GUILabel Name=ErrorMessage3_lbl
         TextFont="XBigFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.800000
         RenderWeight=0.900000
         Name="ErrorMessage3_lbl"
     End Object
     ErrorMessage3=GUILabel'DOTZMenu.XDOTZOverwriteCheckpoint.ErrorMessage3_lbl'
     __OnKeyEvent__Delegate=XDOTZOverwriteCheckpoint.HandleKeyEvent
}
