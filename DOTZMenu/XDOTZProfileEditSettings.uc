// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZLiveMultiplayer
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZProfileEditSettings extends XDOTZProfileBase;



//Page components
var Automated GuiLabel   NameTitleLabel;
var Automated GuiLabel   InvertLookTitleLabel;
var Automated GuiLabel   DifficultyTitleLabel;
//var Automated GuiLabel   VoiceThruSpeakersLabel;
var Automated GuiLabel   VoiceMaskingLabel;
var Automated GuiLabel   UseSubtitlesLabel;
var Automated GuiLabel   UseVibrationLabel;
var Automated GuiLabel   ControllerSensitivityLabel;

var Automated BBXSelectBox   InvertLookValue;
var Automated BBXSelectBox   DifficultyValue;
//var Automated BBXSelectBox   VoiceThruSpeakersValue;
var Automated BBXSelectBox   VoiceMaskingValue;
var Automated BBXSelectBox   UseSubtitlesValue;
var Automated BBXSelectBox   UseVibrationValue;
var Automated BBXSelectBox   ControllerSensitivityValue;
var Automated GuiLabel       NameButton;

// Configurable
var string KeyboardMenu;         // Profile menu location

//configurable stuff
var localized string PageCaption;

var localized string Normaltxt;
var localized string Invertedtxt;
var localized string Easytxt;
var localized string Hardtxt;
//var localized string Speakerstxt;
var localized string HeadSettxt;
var localized string Anonymoustxt;
var localized string Ontxt;
var localized string Offtxt;

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
   AddButtons();

   // Make sure values are all loaded
   //DOTZPlayerControllerBase(PlayerOwner()).SetProfileConfiguration();

   // Set up controls
   InitDynamicValues();

   InvertLookValue.AddItem(Normaltxt);
   InvertLookValue.AddItem(Invertedtxt);
   InvertLookValue.SetIndex(int(DOTZPlayerControllerBase(PlayerOwner()).GetInvertLook()));

   DifficultyValue.AddItem(Easytxt);
   DifficultyValue.AddItem(Normaltxt);
   DifficultyValue.AddItem(Hardtxt);
   DifficultyValue.SetIndex(DOTZPlayerControllerBase(PlayerOwner()).GetDifficultyLevel());

   //VoiceThruSpeakersValue.AddItem(Speakerstxt);
   //VoiceThruSpeakersValue.AddItem(Headsettxt);
   //VoiceThruSpeakersValue.SetIndex(int(!DOTZPlayerControllerBase(PlayerOwner()).GetVoiceThruSpeakers()));

   VoiceMaskingValue.AddItem(Normaltxt);
   VoiceMaskingValue.AddItem(Anonymoustxt);
   VoiceMaskingValue.SetIndex(int(DOTZPlayerControllerBase(PlayerOwner()).GetVoiceMasking()));

   UseSubtitlesValue.AddItem(Offtxt);
   UseSubtitlesValue.AddItem(Ontxt);
   UseSubtitlesValue.SetIndex(int(DOTZPlayerControllerBase(PlayerOwner()).GetUseSubtitles()));

   UseVibrationValue.AddItem(Offtxt);
   UseVibrationValue.AddItem(Ontxt);
   UseVibrationValue.SetIndex(int(DOTZPlayerControllerBase(PlayerOwner()).GetUseVibration()));

   ControllerSensitivityValue.AddItem("1");
   ControllerSensitivityValue.AddItem("2");
   ControllerSensitivityValue.AddItem("3");
   ControllerSensitivityValue.AddItem("4");
   ControllerSensitivityValue.AddItem("5");
   ControllerSensitivityValue.AddItem("6");
   ControllerSensitivityValue.AddItem("7");
   ControllerSensitivityValue.AddItem("8");
   ControllerSensitivityValue.AddItem("9");
   ControllerSensitivityValue.AddItem("10");
   ControllerSensitivityValue.SetIndex(DOTZPlayerControllerBase(PlayerOwner()).GetControllerSensitivity());

   SetFocus(DifficultyValue);
   DifficultyValue.SetFocus(none);

}

/*****************************************************************
 * InitDynamicValues
 * So we can initialize from other delegates too
 *****************************************************************
 */
function AddButtons(){
   //AddBackButton ();
   //AddSelectButton ();
   AddSaveButton ();
}

/*****************************************************************
 * InitDynamicValues
 * So we can initialize from other delegates too
 *****************************************************************
 */
function InitDynamicValues(){
   NameButton.Caption = DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName();
}


/*****************************************************************
 * HandleActivate
 * Delegate for the menu OnActivate event.
 *****************************************************************
 */
function HandleActivate(){
   InitDynamicValues();
}

/*****************************************************************
 * HandleDifficultyChange
 * This code clearly assumes that the index of the combobox is the
 * value of the difficulty 0-3
 *****************************************************************
 */
function HandleDifficultyChange(GUIComponent diffbox){
  DOTZPlayerControllerBase(PlayerOwner()).SetDifficultyLevel(BBXSelectBox(diffbox).GetIndex());
}

/*****************************************************************
 * HandleInvertChange
 * This assumes your index implies a boolean value. index 0 = false
 *****************************************************************
 */
function HandleInvertChange(GUIComponent invertbox){
  DOTZPlayerControllerBase(PlayerOwner()).SetInvertLook(bool(BBXSelectBox(invertbox).GetIndex()));
}

/*****************************************************************
 * HandleVoiceThruSpeakersChange
 *****************************************************************
 */
/*function HandleVoiceThruSpeakersChange(GUIComponent voicethruspeakersbox){
  DOTZPlayerControllerBase(PlayerOwner()).SetVoiceThruSpeakers(!bool(BBXSelectBox(voicethruspeakersbox).GetIndex()));
} */

/*****************************************************************
 * HandleVoiceMaskingChange
 *****************************************************************
 */
function HandleVoiceMaskingChange(GUIComponent voicemaskingbox){
  DOTZPlayerControllerBase(PlayerOwner()).SetVoiceMasking(bool(BBXSelectBox(voicemaskingbox).GetIndex()));
}

/*****************************************************************
 * HandleUseSubtitlesChange
 * This assumes your index implies a boolean value.
 *****************************************************************
 */
function HandleUseSubtitlesChange(GUIComponent usesubtitlesbox){
  DOTZPlayerControllerBase(PlayerOwner()).SetUseSubtitles(bool(BBXSelectBox(usesubtitlesbox).GetIndex()));
}

/*****************************************************************
 * HandleUseVibrationChange
 * This assumes your index implies a boolean value.
 *****************************************************************
 */
function HandleUseVibrationChange(GUIComponent usevibrationbox){
  DOTZPlayerControllerBase(PlayerOwner()).SetUseVibration(bool(BBXSelectBox(usevibrationbox).GetIndex()));
}

/*****************************************************************
 * HandleControllerSensitivityChange
 * This assumes your index implies a boolean value.
 *****************************************************************
 */
function HandleControllerSensitivityChange(GUIComponent sensitivitybox){
  DOTZPlayerControllerBase(PlayerOwner()).SetControllerSensitivity(BBXSelectBox(sensitivitybox).GetIndex());
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
 * Close menus
 *
 *****************************************************************
 */
function CloseMenu ()
{
    BBGuiController(Controller).CloseTo ('XDOTZMainMenu');
}

/*****************************************************************
 * X Button pressed
 *****************************************************************
 */
function DoButtonA ()
{
   //be sure to update your setting when you exit
    HandleDifficultyChange(DifficultyValue);
    HandleInvertChange(InvertLookValue);
    //HandleVoiceThruSpeakersChange(VoiceThruSpeakersValue);
    HandleVoiceMaskingChange(VoiceMaskingValue);
    HandleUseSubtitlesChange(UseSubtitlesValue);
    HandleUseVibrationChange(UseVibrationValue);
    HandleControllerSensitivityChange(ControllerSensitivityValue);

    Log ("Sens " $ ControllerSensitivityValue.GetIndex());

    DOTZPlayerControllerBase(PlayerOwner()).SaveProfile();

    CloseMenu ();
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
function bool ButtonClicked(GUIComponent Sender) {
    /*local GUIButton Selected;

    if (GUIButton(Sender) != None) Selected = GUIButton(Sender);
    if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case NameButton:
             return Controller.OpenMenu(KeyboardMenu);

             return false;
             break;
    };*/

   return false;
}



/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     Begin Object Class=GUILabel Name=NameTitleLabel_lbl
         Caption="Name:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.200000
         WinLeft=0.120000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="NameTitleLabel_lbl"
     End Object
     NameTitleLabel=GUILabel'DOTZMenu.XDOTZProfileEditSettings.NameTitleLabel_lbl'
     Begin Object Class=GUILabel Name=InvertLookTitleLabel_lbl
         Caption="Invert Look:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.480000
         WinLeft=0.120000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="InvertLookTitleLabel_lbl"
     End Object
     InvertLookTitleLabel=GUILabel'DOTZMenu.XDOTZProfileEditSettings.InvertLookTitleLabel_lbl'
     Begin Object Class=GUILabel Name=DifficultyTitleLabel_lbl
         Caption="Single Player Difficulty:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.270000
         WinLeft=0.120000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="DifficultyTitleLabel_lbl"
     End Object
     DifficultyTitleLabel=GUILabel'DOTZMenu.XDOTZProfileEditSettings.DifficultyTitleLabel_lbl'
     Begin Object Class=GUILabel Name=VoiceMaskingLabel_lbl
         Caption="Voice Mask:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.410000
         WinLeft=0.120000
         WinWidth=0.300000
         WinHeight=0.100000
         Name="VoiceMaskingLabel_lbl"
     End Object
     VoiceMaskingLabel=GUILabel'DOTZMenu.XDOTZProfileEditSettings.VoiceMaskingLabel_lbl'
     Begin Object Class=GUILabel Name=UseSubtitlesLabel_lbl
         Caption="Subtitles:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.340000
         WinLeft=0.120000
         WinWidth=0.300000
         WinHeight=0.100000
         Name="UseSubtitlesLabel_lbl"
     End Object
     UseSubtitlesLabel=GUILabel'DOTZMenu.XDOTZProfileEditSettings.UseSubtitlesLabel_lbl'
     Begin Object Class=GUILabel Name=VibrationLabel_lbl
         Caption="Controller Vibration:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.550000
         WinLeft=0.120000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="VibrationLabel_lbl"
     End Object
     UseVibrationLabel=GUILabel'DOTZMenu.XDOTZProfileEditSettings.VibrationLabel_lbl'
     Begin Object Class=GUILabel Name=ControllerSensitivityLabel_lbl
         Caption="Controller Sensitivity:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.620000
         WinLeft=0.120000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="ControllerSensitivityLabel_lbl"
     End Object
     ControllerSensitivityLabel=GUILabel'DOTZMenu.XDOTZProfileEditSettings.ControllerSensitivityLabel_lbl'
     Begin Object Class=BBXSelectBox Name=InvertLookValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.500000
         WinLeft=0.480000
         WinWidth=0.400000
         WinHeight=0.060000
         Name="InvertLookValue_lbl"
     End Object
     InvertLookValue=BBXSelectBox'DOTZMenu.XDOTZProfileEditSettings.InvertLookValue_lbl'
     Begin Object Class=BBXSelectBox Name=DifficultyValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.290000
         WinLeft=0.480000
         WinWidth=0.400000
         WinHeight=0.060000
         Name="DifficultyValue_lbl"
     End Object
     DifficultyValue=BBXSelectBox'DOTZMenu.XDOTZProfileEditSettings.DifficultyValue_lbl'
     Begin Object Class=BBXSelectBox Name=VoiceMaskingValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.430000
         WinLeft=0.480000
         WinWidth=0.400000
         WinHeight=0.060000
         Name="VoiceMaskingValue_lbl"
     End Object
     VoiceMaskingValue=BBXSelectBox'DOTZMenu.XDOTZProfileEditSettings.VoiceMaskingValue_lbl'
     Begin Object Class=BBXSelectBox Name=UseSubtitlesValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.360000
         WinLeft=0.480000
         WinWidth=0.400000
         WinHeight=0.060000
         Name="UseSubtitlesValue_lbl"
     End Object
     UseSubtitlesValue=BBXSelectBox'DOTZMenu.XDOTZProfileEditSettings.UseSubtitlesValue_lbl'
     Begin Object Class=BBXSelectBox Name=VibrationValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.570000
         WinLeft=0.480000
         WinWidth=0.400000
         WinHeight=0.060000
         Name="VibrationValue_lbl"
     End Object
     UseVibrationValue=BBXSelectBox'DOTZMenu.XDOTZProfileEditSettings.VibrationValue_lbl'
     Begin Object Class=BBXSelectBox Name=ControllerSensitivityValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.640000
         WinLeft=0.480000
         WinWidth=0.400000
         WinHeight=0.060000
         Name="ControllerSensitivityValue_lbl"
     End Object
     ControllerSensitivityValue=BBXSelectBox'DOTZMenu.XDOTZProfileEditSettings.ControllerSensitivityValue_lbl'
     Begin Object Class=GUILabel Name=NameButton_btn
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.220000
         WinLeft=0.480000
         WinWidth=0.400000
         WinHeight=0.060000
         Name="NameButton_btn"
     End Object
     NameButton=GUILabel'DOTZMenu.XDOTZProfileEditSettings.NameButton_btn'
     KeyboardMenu="DOTZMenu.XDOTZKeyboard"
     PageCaption="Settings"
     Normaltxt="Normal"
     Invertedtxt="Inverted"
     Easytxt="Easy"
     Hardtxt="Hard"
     Anonymoustxt="Anonymous"
     Ontxt="On"
     Offtxt="Off"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnActivate__Delegate=XDOTZProfileEditSettings.HandleActivate
     __OnKeyEvent__Delegate=XDOTZProfileEditSettings.HandleKeyEvent
}
