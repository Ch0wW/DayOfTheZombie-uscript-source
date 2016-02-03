// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZLiveMultiplayer
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZLiveOptiMatch extends XDOTZLiveMatchPage;



//Page components
var Automated GuiLabel   GametypeTitleLabel;
var Automated GuiLabel   MaxPlayersTitleLabel;

var Automated BBXSelectBox   GametypeSelect;
var Automated BBXSelectBox   MaxPlayersValue;

var Automated GuiButton  SearchMatchButton;

//configurable stuff
var localized string PageCaption;

// Menu locations
var string    ErrorMenu;
var string    GettingMatchesMenu;

var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner )
{
   Super.Initcomponent(MyController, MyOwner);
   // init my components...

   SetPageCaption (PageCaption);
   AddBackButton ();
   //AddSelectButton ();
   AddContinueButton();

   // Populate Menus

   // Game type
   FillInGameTypesAny(GametypeSelect);
   GametypeSelect.SetIndex(4);

   // Max players
//   FillInPlayerLimitsAny(MaxPlayersValue);
  // MaxPlayersValue.SetIndex(8);
}


/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
    super.Opened(Sender);
}

function GameTypeChange( GUIComponent Sender ) {
   FillInPlayerLimitsAny(MaxPlayersValue, GameTypeSelect.List.Index);
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
 * A Button pressed
 *****************************************************************
 */

function DoButtonA ()
{
     local int gametype;
     local int maxplayers;
     local int error;

     // Get the values for the query
     gametype = GametypeSelect.List.Index;
     maxplayers = MaxPlayersValue.List.Index + 1;

     // Check for wildcard
     if (IsGameTypeIndexWildcard(gametype))
         gametype = -1;

     if (IsPlayerIndexWildcard(gametype, maxplayers))
         maxplayers = -1;

     Log("Searching for matches " $ gametype $ " " $ maxplayers);


     // Query the match making service
     class'UtilsXbox'.static.Match_Refresh_Criteria (gametype, maxplayers);

     // Check errors
     error = class'UtilsXbox'.static.Get_Last_Error();
     if (error > 0) {
        Controller.OpenMenu(ErrorMenu);
     } else {
        Controller.OpenMenu(GettingMatchesMenu, "DOTZMenu.XDOTZLiveOptiMatchResults");
     }
}

/*****************************************************************
 * B Button pressed
 *****************************************************************
 */

function DoButtonB ()
{
    BBGuiController(Controller).CloseTo ('XDOTZLiveMultiplayer');
}

/*****************************************************************
 * X Button pressed
 *****************************************************************
 */

function DoButtonX ()
{

}

/*****************************************************************
 * NotifyLevelChange
 *****************************************************************
 */

event NotifyLevelChange()
{
    Controller.CloseMenu(true);
}


/*****************************************************************
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */
/*function bool ButtonClicked(GUIComponent Sender) {
    local GUIButton Selected;
    local int gametype;
    local int maxplayers;
    local int error;

    if (GUIButton(Sender) != None) Selected = GUIButton(Sender);
    if (Selected == None) return false;


    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case SearchMatchButton:
             // Get the values for the query
             gametype = GametypeSelect.List.Index;
             maxplayers = MaxPlayersValue.List.Index + 1;

             // Check for wildcard
             if (IsGameTypeIndexWildcard(gametype))
                 gametype = -1;

             if (IsPlayerIndexWildcard(maxplayers))
                 maxplayers = -1;

             // Query the match making service
             class'UtilsXbox'.static.Match_Refresh_Criteria (gametype, maxplayers);

             // Check errors
             error = class'UtilsXbox'.static.Get_Last_Error();
             if (error > 0) {
                Controller.OpenMenu(ErrorMenu);
             } else {
                Controller.OpenMenu(GettingMatchesMenu, "DOTZMenu.XDOTZLiveOptiMatchResults");
             }

             return false;
             break;
    };

   return false;
}  */


/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     Begin Object Class=GUILabel Name=GametypeTitleLabel_lbl
         Caption="Game Type:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.390000
         WinLeft=0.200000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="GametypeTitleLabel_lbl"
     End Object
     GametypeTitleLabel=GUILabel'DOTZMenu.XDOTZLiveOptiMatch.GametypeTitleLabel_lbl'
     Begin Object Class=GUILabel Name=MaxPlayersTitleLabel_lbl
         Caption="Max Players:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.470000
         WinLeft=0.200000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="MaxPlayersTitleLabel_lbl"
     End Object
     MaxPlayersTitleLabel=GUILabel'DOTZMenu.XDOTZLiveOptiMatch.MaxPlayersTitleLabel_lbl'
     Begin Object Class=BBXSelectBox Name=GametypeValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.410000
         WinLeft=0.400000
         WinWidth=0.400000
         WinHeight=0.060000
         __OnChange__Delegate=XDOTZLiveOptiMatch.GameTypeChange
         Name="GametypeValue_lbl"
     End Object
     GameTypeSelect=BBXSelectBox'DOTZMenu.XDOTZLiveOptiMatch.GametypeValue_lbl'
     Begin Object Class=BBXSelectBox Name=MaxPlayersValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.490000
         WinLeft=0.400000
         WinWidth=0.400000
         WinHeight=0.060000
         Name="MaxPlayersValue_lbl"
     End Object
     MaxPlayersValue=BBXSelectBox'DOTZMenu.XDOTZLiveOptiMatch.MaxPlayersValue_lbl'
     PageCaption="OptiMatch"
     ErrorMenu="DOTZMenu.XDOTZLiveError"
     GettingMatchesMenu="DOTZMenu.XDOTZLiveGettingMatches"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLiveOptiMatch.HandleKeyEvent
}
