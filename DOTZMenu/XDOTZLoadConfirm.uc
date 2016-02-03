// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    Sept 2003
 */
class XDOTZLoadConfirm extends XDOTZErrorPage;

var localized string LoadMessage1;
var localized string LoadMessage2;
var localized string load_string;

var string mapname;

var Automated GUILabel   ErrorMessage2;        // The error message to be displayed
var Automated GUILabel   ErrorMessage3;        // The error message to be displayed

/*****************************************************************
 * Opened
 *****************************************************************
 */
event Opened( GUIComponent Sender ) {
    //local string tmp;

    Super.Opened(Sender);

    mapname = GameSpecificLevelInfo(PlayerOwner().Level.GameSpecificLevelInfo).LevelName
        @ "-" @ "Checkpoint" @ PlayerOwner().Level.ActiveCheckPointID;

    //“Are you sure you want to load Checkpoint 1 – The farm? Your current level progress will be lost.”
    SetErrorCaption( LoadMessage1 );
    ErrorMessage2.Caption = mapname $ "?";
    ErrorMessage3.Caption = LoadMessage2;

    AddBackButton(cancel_string);
    AddSelectButton(load_string);
}

/*****************************************************************
 * HandleParameters
 * When open menu get's called, the parameter values are supplied here.
 *****************************************************************
 */
event HandleParameters( String param1, String param2 ) {

}

/*****************************************************************
 * DoButtonA
 *****************************************************************
 */
function DoButtonA(){
    local string mapname;
    // Display loading screen
    //Log("Controller opening loading screen");
    Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu");

    mapname = GameSpecificLevelInfo(PlayerOwner().Level.GameSpecificLevelInfo).LevelName
        @ "-" @ "Checkpoint" @ PlayerOwner().Level.ActiveCheckPointID;

    // Load to last checkpoint
    Controller.ConsoleCommand( "loadcheckpoint \"" $ mapname $ "\"");

   // load the game
   //class'UtilsXbox'.static.Set_Reboot_Type(5);   // Is single player
   //Log("Client travel to " $ loadgame);
   //PlayerOwner().ClientTravel( "?loadnamed=" $ EncodeStringURL(LoadName),TRAVEL_Absolute, false );
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
     LoadMessage1="Are you sure you want to load"
     LoadMessage2="Your current level progress will be lost."
     load_string="Load"
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
     ErrorMessage2=GUILabel'DOTZMenu.XDOTZLoadConfirm.ErrorMessage2_lbl'
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
     ErrorMessage3=GUILabel'DOTZMenu.XDOTZLoadConfirm.ErrorMessage3_lbl'
     __OnKeyEvent__Delegate=XDOTZLoadConfirm.HandleKeyEvent
}
