// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZProfileGameSettings
 * -users can change gameplay settings using this GUI
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #1 $
 * @date    May 2005
 */
class DOTZProfileGameSettings extends DOTZProfilePanel;



var Automated GUILabel DifficultyLabel;
var Automated GUILabel AutosaveLabel;
var Automated GUILabel ReticuleLabel;
var Automated GUILabel SubtitlesLabel;

var Automated GuiComboBox DifficultyBox;
var Automated moCheckBox AutosaveBox;
var Automated moCheckBox ReticuleBox;
var Automated moCheckBox SubtitlesBox;

var sound clickSound;

const constAUTOSAVE = "AUTOSAVE";
const constRETICULE = "RETICULE";

const constTRUE = "true";
const constFALSE = "false";

var localized string Normaltxt;
var localized string Easytxt;
var localized string Hardtxt;



/****************************************************************
 * InitComponents
 ****************************************************************
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner)
{

   Super.InitComponent(MyController,MyOwner);

   LoadValues();
}


/****************************************************************
 * LoadValues
 * -populates GUI fields with info from currently loaded profile
 ****************************************************************
 */
function LoadValues()
{
    local string temp;

    temp = DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName();
    if(temp == "")
    {
        return;
    }

    // Load the difficulty setting
    DifficultyBox.AddItem(Easytxt);
    DifficultyBox.AddItem(Normaltxt);
    DifficultyBox.AddItem(Hardtxt);
    Log("level:" @DOTZPlayerControllerBase(PlayerOwner()).GetDifficultyLevel());
    DifficultyBox.List.SetIndex(DOTZPlayerControllerBase(PlayerOwner()).GetDifficultyLevel());

    // Load the autosave setting
    temp = class'Profiler'.static.GetValue(constAUTOSAVE);
    if(temp == constFALSE)
        AutosaveBox.Checked(false);
    else
        AutosaveBox.Checked(true);

    // Load the reticule setting
    temp = class'Profiler'.static.GetValue(constRETICULE);
    if(temp == constFALSE)
        ReticuleBox.Checked(false);
    else
        ReticuleBox.Checked(true);

    // Load the subtitle setting
    if(DOTZPlayerControllerBase(PlayerOwner()).GetUseSubtitles())
        SubtitlesBox.Checked(true);
    else
        SubtitlesBox.Checked(false);
}


/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled)
{
    UpdateProfile();
    Super.Closed(Sender,bCancelled);
    Controller.MouseEmulation(false);
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
 * HandleDifficultyChange
 *****************************************************************
 */
function HandleDifficultyChange(GUIComponent Sender)
{
    Log("setting:"@DifficultyBox.List.Index);
    DOTZPlayerControllerBase(PlayerOwner()).SetDifficultyLevel(DifficultyBox.List.Index);
}

/*****************************************************************
 * HandleAutosaveChange
 *****************************************************************
 */
function HandleAutosaveChange(GUIComponent Sender)
{
    if(AutosaveBox.IsChecked())
        class'Profiler'.static.SetValue(constAUTOSAVE, constTRUE);
    else
        class'Profiler'.static.SetValue(constAUTOSAVE, constFALSE);
}

/*****************************************************************
 * HandleReticuleChange
 *****************************************************************
 */
function HandleReticuleChange(GUIComponent Sender)
{
    if(ReticuleBox.IsChecked())
        class'Profiler'.static.SetValue(constRETICULE, constTRUE);
    else
        class'Profiler'.static.SetValue(constRETICULE, constFALSE);
}

/*****************************************************************
 * HandleSubtitlesChange
 *****************************************************************
 */
function HandleSubtitlesChange(GUIComponent Sender)
{
    //DOTZPlayerControllerBase(PlayerOwner()).SetUseSubtitles(SubtitlesBox.IsChecked());
    DOTZPlayerControllerBase(PlayerOwner()).SetUseSubtitles(SubtitlesBox.IsChecked());
    /*
    if(SubtitlesBox.IsChecked())
        DOTZPlayerControllerBase(PlayerOwner()).class'Profiler'.static.SetValue(constSUBTITLES, constTRUE);
    else
        DOTZPlayerControllerBase(PlayerOwner()).class'Profiler'.static.SetValue(constSUBTITLES, constFALSE);
    */
}


/*****************************************************************
 * UpdateProfile
 *****************************************************************
 */
function bool UpdateProfile()
{
    HandleDifficultyChange(Self);
    HandleAutosaveChange(Self);
    HandleReticuleChange(Self);
    HandleSubtitlesChange(Self);

    // Save entire profile
    //DOTZPlayerControllerBase(PlayerOwner()).SaveProfile();
    DOTZPlayerControllerBase(PlayerOwner()).SaveProfile();
    return true;
}

defaultproperties
{
     Begin Object Class=GUILabel Name=difficulty_label
         Caption="Difficulty"
         TextColor=(B=119,G=243,R=248)
         TextFont="BoldGuiFont"
         WinTop=0.100000
         WinLeft=0.170000
         WinWidth=0.275000
         WinHeight=0.060000
         Name="difficulty_label"
     End Object
     DifficultyLabel=GUILabel'DOTZMenu.DOTZProfileGameSettings.difficulty_label'
     Begin Object Class=GUILabel Name=autosave_label
         Caption="Enable autosave"
         TextColor=(B=119,G=243,R=248)
         TextFont="BoldGuiFont"
         WinTop=0.225000
         WinLeft=0.170000
         WinWidth=0.275000
         WinHeight=0.060000
         Name="autosave_label"
     End Object
     AutosaveLabel=GUILabel'DOTZMenu.DOTZProfileGameSettings.autosave_label'
     Begin Object Class=GUILabel Name=RETICULE_LABEL
         Caption="Enable reticule"
         TextColor=(B=119,G=243,R=248)
         TextFont="BoldGuiFont"
         WinTop=0.350000
         WinLeft=0.170000
         WinWidth=0.275000
         WinHeight=0.060000
         Name="RETICULE_LABEL"
     End Object
     ReticuleLabel=GUILabel'DOTZMenu.DOTZProfileGameSettings.RETICULE_LABEL'
     Begin Object Class=GUILabel Name=Subtitles_label
         Caption="Use subtitles"
         TextColor=(B=119,G=243,R=248)
         TextFont="BoldGuiFont"
         WinTop=0.475000
         WinLeft=0.170000
         WinWidth=0.275000
         WinHeight=0.060000
         Name="Subtitles_label"
     End Object
     SubtitlesLabel=GUILabel'DOTZMenu.DOTZProfileGameSettings.Subtitles_label'
     Begin Object Class=BBComboBox Name=Difficulty_edit
         Hint="Choose the game difficulty"
         WinTop=0.100000
         WinLeft=0.550000
         WinWidth=0.300000
         Name="Difficulty_edit"
     End Object
     DifficultyBox=BBComboBox'DOTZMenu.DOTZProfileGameSettings.Difficulty_edit'
     Begin Object Class=moCheckBox Name=autosave_box
         ComponentClassName="BBGui.BBCheckBoxButton"
         LabelFont="BigGuiFont"
         StyleName="BBSquareButton"
         bNeverFocus=True
         WinTop=0.225000
         WinLeft=0.550000
         WinWidth=0.060000
         TabOrder=1
         Name="autosave_box"
     End Object
     AutosaveBox=moCheckBox'DOTZMenu.DOTZProfileGameSettings.autosave_box'
     Begin Object Class=moCheckBox Name=RETICULE_BOX
         ComponentClassName="BBGui.BBCheckBoxButton"
         LabelFont="BigGuiFont"
         StyleName="BBSquareButton"
         bNeverFocus=True
         WinTop=0.350000
         WinLeft=0.550000
         WinWidth=0.060000
         TabOrder=2
         Name="RETICULE_BOX"
     End Object
     ReticuleBox=moCheckBox'DOTZMenu.DOTZProfileGameSettings.RETICULE_BOX'
     Begin Object Class=moCheckBox Name=Subtitles_box
         ComponentClassName="BBGui.BBCheckBoxButton"
         LabelFont="BigGuiFont"
         StyleName="BBSquareButton"
         bNeverFocus=True
         WinTop=0.475000
         WinLeft=0.550000
         WinWidth=0.060000
         TabOrder=3
         Name="Subtitles_box"
     End Object
     SubtitlesBox=moCheckBox'DOTZMenu.DOTZProfileGameSettings.Subtitles_box'
     ClickSound=Sound'DOTZXInterface.Select'
     Normaltxt="Normal"
     Easytxt="Easy"
     Hardtxt="Hard"
     WinTop=55.980499
     WinHeight=0.807813
}
