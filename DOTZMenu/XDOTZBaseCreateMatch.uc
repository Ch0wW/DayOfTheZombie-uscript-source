// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZLiveMultiplayer
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZBaseCreateMatch extends XDOTZLiveMatchPage;



//Page components
var Automated GuiLabel   GametypeTitleLabel;
var Automated GuiLabel   MapsTitleLabel;
var Automated GuiLabel   TimeLimitTitleLabel;
var Automated GuiLabel   ScoreLimitTitleLabel;
var Automated GuiLabel   MaxPlayersTitleLabel;
var Automated GuiLabel   FriendlyFireTitleLabel;
var Automated GuiLabel   EnemyStrengthLabel;

var Automated BBXSelectBox GameTypeSelect;
var Automated BBXSelectBox MapsSelect;
var Automated BBXSelectBox TimeLimitSelect;
var Automated BBXSelectBox   ScoreLimitValue;
var Automated BBXSelectBox   MaxPlayersValue;
var Automated BBXSelectBox   FriendlyFireValue;
var Automated BBXSelectBox   EnemyStrengthValue;

//var Automated GuiButton  CreateMatchButton;


var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner )
{
   Super.Initcomponent(MyController, MyOwner);
   // init my components...

   AddBackButton ();
   AddContinueButton ();

   // Populate Menus

   // Game type
   FillInGameTypes(GametypeSelect);

   // Time limit
   FillInTimeLimits(TimeLimitSelect);
   TimeLimitSelect.SetIndex(9);

   // Score limit
   //FillInScoreLimits(ScoreLimitValue, GametypeSelect.List.Index);
   //ScoreLimitValue.AddItem(UnlimitedText);

   // Max players
   //FillInPlayerLimits(MaxPlayersValue);
   //MaxPlayersValue.SetIndex(7);

   //Friendly Fire
   FriendlyFireValue.AddItem(IntToYesNo(0));
   FriendlyFireValue.AddItem(IntToYesNo(1));

   EnemyStrengthValue.AddItem(EnemyPatheticTxt);
   EnemyStrengthValue.AddItem(EnemyNormalTxt);
   EnemyStrengthValue.AddItem(EnemyImpossibleTxt);
   EnemyStrengthValue.SetIndex(1);
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
 * A Button pressed
 *****************************************************************
 */

function DoButtonA ()
{
    StartHosting ();
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
 * NotifyLevelChange
 *****************************************************************
 */

event NotifyLevelChange()
{
    Controller.CloseMenu(true);
}

/*****************************************************************
 * Game type change
 *****************************************************************
 */

function GameTypeChange( GUIComponent Sender ) {
   // Maps
   MapsSelect.List.Clear();
   FillInMapTitles(MapsSelect, GametypeSelect.List.Index);

   //score limits
   ScoreLimitValue.List.Clear();
   FillInScoreLimits(ScoreLimitValue, GametypeSelect.List.Index);

   FillInPlayerLimits(MaxPlayersValue, GameTypeSelect.List.Index);


}

/*****************************************************************
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */

function StartHosting () {

}

/*****************************************************************
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */
function bool ButtonClicked(GUIComponent Sender) {
    local GUIButton Selected;

    if (GUIButton(Sender) != none || BBXSelectBox(Sender) !=none) {
      Selected = GUIButton(Sender);
    }
    if (Selected == None) return false;


   	PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        /*case CreateMatchButton:
             StartHosting ();
             return false;
             break;*/
    };

   return false;
}


/*****************************************************************
 * SetTeamMatchStatus
 * Use the notification to determine if a friendlyfire button makes
 * any sense to display
 *****************************************************************
 */
function SetTeamMatchStatus(bool IsTeamGame){
   super.SetTeamMatchStatus(IsTeamGame);
   FriendlyFireValue.bNeverFocus = !IsTeamGame;
   FriendlyFireValue.bVisible = IsTeamGame;
   FriendlyFireTitleLabel.bVisible = IsTeamGame;
   MapControls();
}


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
         WinTop=0.200000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="GametypeTitleLabel_lbl"
     End Object
     GametypeTitleLabel=GUILabel'DOTZMenu.XDOTZBaseCreateMatch.GametypeTitleLabel_lbl'
     Begin Object Class=GUILabel Name=MapsTitleLabel_lbl
         Caption="Map:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.270000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="MapsTitleLabel_lbl"
     End Object
     MapsTitleLabel=GUILabel'DOTZMenu.XDOTZBaseCreateMatch.MapsTitleLabel_lbl'
     Begin Object Class=GUILabel Name=TimeLimitTitleLabel_lbl
         Caption="Time Limit:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.340000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="TimeLimitTitleLabel_lbl"
     End Object
     TimeLimitTitleLabel=GUILabel'DOTZMenu.XDOTZBaseCreateMatch.TimeLimitTitleLabel_lbl'
     Begin Object Class=GUILabel Name=ScoreLimitTitleLabel_lbl
         Caption="Score Limit:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.410000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="ScoreLimitTitleLabel_lbl"
     End Object
     ScoreLimitTitleLabel=GUILabel'DOTZMenu.XDOTZBaseCreateMatch.ScoreLimitTitleLabel_lbl'
     Begin Object Class=GUILabel Name=MaxPlayersTitleLabel_lbl
         Caption="Max Players:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.480000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="MaxPlayersTitleLabel_lbl"
     End Object
     MaxPlayersTitleLabel=GUILabel'DOTZMenu.XDOTZBaseCreateMatch.MaxPlayersTitleLabel_lbl'
     Begin Object Class=GUILabel Name=FriendlyFireTitleLabel_lbl
         Caption="Friendly Fire:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         WinTop=0.620000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="FriendlyFireTitleLabel_lbl"
     End Object
     FriendlyFireTitleLabel=GUILabel'DOTZMenu.XDOTZBaseCreateMatch.FriendlyFireTitleLabel_lbl'
     Begin Object Class=GUILabel Name=EnemyStrengthLabel_lbl
         Caption="Enemy Resilience:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.550000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="EnemyStrengthLabel_lbl"
     End Object
     EnemyStrengthLabel=GUILabel'DOTZMenu.XDOTZBaseCreateMatch.EnemyStrengthLabel_lbl'
     Begin Object Class=BBXSelectBox Name=GametypeValue_lbl
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.220000
         WinLeft=0.450000
         WinWidth=0.400000
         WinHeight=0.060000
         __OnClick__Delegate=XDOTZBaseCreateMatch.ButtonClicked
         __OnChange__Delegate=XDOTZBaseCreateMatch.GameTypeChange
         Name="GametypeValue_lbl"
     End Object
     GameTypeSelect=BBXSelectBox'DOTZMenu.XDOTZBaseCreateMatch.GametypeValue_lbl'
     Begin Object Class=BBXSelectBox Name=MapsValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.290000
         WinLeft=0.450000
         WinWidth=0.400000
         WinHeight=0.060000
         __OnClick__Delegate=XDOTZBaseCreateMatch.ButtonClicked
         Name="MapsValue_lbl"
     End Object
     MapsSelect=BBXSelectBox'DOTZMenu.XDOTZBaseCreateMatch.MapsValue_lbl'
     Begin Object Class=BBXSelectBox Name=TimeLimitValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.360000
         WinLeft=0.450000
         WinWidth=0.400000
         WinHeight=0.060000
         Name="TimeLimitValue_lbl"
     End Object
     TimeLimitSelect=BBXSelectBox'DOTZMenu.XDOTZBaseCreateMatch.TimeLimitValue_lbl'
     Begin Object Class=BBXSelectBox Name=ScoreLimitValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.430000
         WinLeft=0.450000
         WinWidth=0.400000
         WinHeight=0.060000
         Name="ScoreLimitValue_lbl"
     End Object
     ScoreLimitValue=BBXSelectBox'DOTZMenu.XDOTZBaseCreateMatch.ScoreLimitValue_lbl'
     Begin Object Class=BBXSelectBox Name=MaxPlayersValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.500000
         WinLeft=0.450000
         WinWidth=0.400000
         WinHeight=0.060000
         Name="MaxPlayersValue_lbl"
     End Object
     MaxPlayersValue=BBXSelectBox'DOTZMenu.XDOTZBaseCreateMatch.MaxPlayersValue_lbl'
     Begin Object Class=BBXSelectBox Name=FriendlyFireValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.640000
         WinLeft=0.450000
         WinWidth=0.400000
         WinHeight=0.060000
         Name="FriendlyFireValue_lbl"
     End Object
     FriendlyFireValue=BBXSelectBox'DOTZMenu.XDOTZBaseCreateMatch.FriendlyFireValue_lbl'
     Begin Object Class=BBXSelectBox Name=EnemyStrengthValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.570000
         WinLeft=0.450000
         WinWidth=0.400000
         WinHeight=0.060000
         Name="EnemyStrengthValue_lbl"
     End Object
     EnemyStrengthValue=BBXSelectBox'DOTZMenu.XDOTZBaseCreateMatch.EnemyStrengthValue_lbl'
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZBaseCreateMatch.HandleKeyEvent
}
