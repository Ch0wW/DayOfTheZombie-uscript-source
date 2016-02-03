// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * A one-page configuration panel, which covers coarse graphics and
 * sound settings.
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    Oct 2003
 */
class DOTZGameSettings extends DOTZSettingsPanel;



var(Object) int DebugFlags;

//control numbers
const DIFF_LABEL = 0;
const DIFF_BOX = 1;
const AUTO_LABEL = 2;
const AUTO_BOX = 3;
const RETICULE_LABEL = 4;
const RETICULE_BOX = 5;



// game difficulty
struct DifficultyLevel {
   var int playerHealth;
   var string label;
};



// internal
var private bool bInitialized;
var localized Array<DifficultyLevel> difficultyLevels;

var sound ClickSound;


/****************************************************************
 * InitComponent
 ****************************************************************
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner) {
   local int i;

   Super.InitComponent(MyController,MyOwner);
   //init the game difficulty
   for ( i = 0; i < difficultyLevels.length; ++i ) {
      GuiComboBox(Controls[DIFF_BOX]).AddItem( difficultyLevels[i].label );
   }
   InitDifficultyBox( Controls[DIFF_BOX], "INIT-DIFFICULTY" );
   //init autosaves
   moCheckBox(Controls[AUTO_BOX])
        .Checked(!class'AdvancedGameInfo'.default.bAutoSaveDisabled);
   //init reticule
   moCheckBox(Controls[RETICULE_BOX])
        .Checked(class'AdvancedGameInfo'.default.bUseReticule);


   bInitialized = true;
}

/****************************************************************
 * InitDifficultyBox
 ****************************************************************
 */
function InitDifficultyBox(GUIComponent Sender, string s) {

    local int prevDifficultyIdx;
    


                // Log( self @ "InternalOnLoadINI [" $Sender$ "] [" $s$ "]"  )    ;

    switch ( DOTZPlayerControllerBase(PlayerOwner()).GetDifficultyLevel()){ //Class'AdvancedGameInfo'.default.currentDifficultyLevel ) {
    case 2:
        prevDifficultyIdx = 2;
        break;
    case 0:
        prevDifficultyIdx = 0;
        break;
    case 1:
    // fall through to default...
    default:
        prevDifficultyIdx = 1;
    }
    



                // Log( self @ logout  )    ;
    GuiComboBox(Controls[DIFF_BOX])
        .SetText(difficultyLevels[prevDifficultyIdx].Label);
    GuiComboBox(Controls[DIFF_BOX])
        .SetIndex( prevDifficultyIdx );
}

/****************************************************************
 * DifficultyChange
 ****************************************************************
 */
function DifficultyChange(GUIComponent Sender) {
   local int diffIdx;
   local AdvancedPawn TempPawn;
   local RailShooter TempRail;
   local int OldLevel;

   if ( !bInitialized || GUIComboBox(Controls[DIFF_BOX]).ItemCount()
                            < difficultyLevels.length ) {
      return;
   }

    //the level you start with
   OldLevel = class'AdvancedGameInfo'.default.iDifficultyLevel;

   diffIdx = GUIComboBox(Sender).getIndex();
   if ( GuiComboBox(Sender) != None) {
      //update pawns with new difficulty levels
      foreach PlayerOwner().AllActors(class'AdvancedPawn', TempPawn){
         TempPawn.UpdateDifficultyLevel(diffIdx);
      }
      //update railshooter with new difficulty levels
      foreach PlayerOwner().AllActors(class'RailShooter', TempRail){
         TempRail.UpdateDifficultyLevel(diffIdx);
      }
      DOTZPlayerControllerBase(PlayerOwner()).SetDifficultyLevel(diffIdx);

      //note the hack here to uncheck the box on difficult
      //ONLY do it if you are REALLY changed the settings
      if (diffIdx != OldLevel){
        if (diffIdx == 2){
              moCheckBox(Controls[RETICULE_BOX]).Checked(false);
          } else {
              moCheckBox(Controls[RETICULE_BOX]).Checked(true);
          }
      }

      //class'AdvancedGameInfo'.default.currentDifficultyLevel=difficultyLevels[diffIdx].label;
      class'AdvancedGameInfo'.default.iDifficultyLevel=diffIdx;
      Class'AdvancedGameInfo'.static.StaticSaveConfig();
                  // Log( self @ "supposed to save" @ difficultyLevels[diffIdx].label @ "sent by" @ Sender  )    ;
   }
}



/****************************************************************
 * OnAutoSaveChanged
 ****************************************************************
 */
function OnAutoSaveChanged(GUIComponent Sender){
    local bool bIsChecked;

    if ( bInitialized == false){
        return;
    }
    bIsChecked = moCheckBox(Sender).IsChecked();
    class'AdvancedGameInfo'.default.bAutoSaveDisabled = !bIsChecked;
    class'AdvancedGameInfo'.static.StaticSaveConfig();
               // Log( self @ "Saved autosave setting" @ class'AdvancedGameInfo'.default.bAutoSaveDisabled  )    ;
}


/*****************************************************************
 * OnReticuleChanged
 *****************************************************************
 */
function OnReticuleChanged(GUIComponent Sender){
    local bool bIsChecked;

    if ( bInitialized == false){
        return;
    }
    bIsChecked = moCheckBox(Sender).IsChecked();
    class'AdvancedGameInfo'.default.bUseReticule = bIsChecked;
    class'AdvancedGameInfo'.static.StaticSaveConfig();

}

/****************************************************************
 * InternalOnSaveINI
 ****************************************************************
 */
function string InternalOnSaveINI(GUIComponent Sender);


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     DebugFlags=1
     difficultyLevels(0)=(playerHealth=10000,Label="Easy")
     difficultyLevels(1)=(playerHealth=4500,Label="Standard")
     difficultyLevels(2)=(playerHealth=2000,Label="Difficult")
     ClickSound=Sound'DOTZXInterface.Select'
     Controls(0)=GUILabel'DOTZMenu.DOTZGameSettings.difficulty_label'
     Controls(1)=BBComboBox'DOTZMenu.DOTZGameSettings.cComboBox1'
     Controls(2)=GUILabel'DOTZMenu.DOTZGameSettings.autosave_label'
     Controls(3)=moCheckBox'DOTZMenu.DOTZGameSettings.autosave_box'
     Controls(4)=GUILabel'DOTZMenu.DOTZGameSettings.reticule_label1'
     Controls(5)=moCheckBox'DOTZMenu.DOTZGameSettings.reticule_box1'
     WinTop=55.980499
     WinHeight=0.807813
}
