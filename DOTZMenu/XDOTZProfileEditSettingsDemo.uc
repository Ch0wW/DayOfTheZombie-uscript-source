// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZProfileEditSettingsDemo - Profile Edit Demo version
 *  -ripped from XDOTZProfileEditSettings
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #1 $
 * @date    June 20, 2005
 */

class XDOTZProfileEditSettingsDemo extends XDOTZDemo;



//Page components
var Automated GuiLabel   NameTitleLabel;
var Automated GuiLabel   InvertLookTitleLabel;
var Automated GuiLabel   DifficultyTitleLabel;
var Automated GuiLabel   UseSubtitlesLabel;
var Automated GuiLabel   UseVibrationLabel;

var Automated GuiLabel    NameButton;
var Automated BBXSelectBox   InvertLookValue;
var Automated BBXSelectBox   DifficultyValue;
var Automated BBXSelectBox   UseSubtitlesValue;
var Automated BBXSelectBox   UseVibrationValue;

// Configurable
var string KeyboardMenu;         // Profile menu location

//configurable stuff
var localized string PageCaption;

var localized string Normaltxt;
var localized string Invertedtxt;
var localized string Easytxt;
var localized string Hardtxt;
var localized string Speakerstxt;
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
   AddBackButton ();
   //AddSelectButton ();

   // Set up controls
   InitDynamicValues();

   // Load up profile info from DemoProfile
   DOTZPlayerControllerBase(PlayerOwner()).DemoProfileConfig();

   InvertLookValue.AddItem(Normaltxt);
   InvertLookValue.AddItem(Invertedtxt);
   InvertLookValue.SetIndex(int(DOTZPlayerControllerBase(PlayerOwner()).GetInvertLook()));

   DifficultyValue.AddItem(Easytxt);
   DifficultyValue.AddItem(Normaltxt);
   DifficultyValue.AddItem(Hardtxt);
   DifficultyValue.SetIndex(DOTZPlayerControllerBase(PlayerOwner()).GetDifficultyLevel());

   UseSubtitlesValue.AddItem(Offtxt);
   UseSubtitlesValue.AddItem(Ontxt);
   UseSubtitlesValue.SetIndex(int(DOTZPlayerControllerBase(PlayerOwner()).GetUseSubtitles()));

   UseVibrationValue.AddItem(Offtxt);
   UseVibrationValue.AddItem(Ontxt);
   UseVibrationValue.SetIndex(int(DOTZPlayerControllerBase(PlayerOwner()).GetUseVibration()));

   LiveCaption.bVisible = false;
}




/*****************************************************************
 * InitDynamicValues
 * So we can initialize from other delegates too
 *****************************************************************
 */
function InitDynamicValues(){
   //NameButton.Caption = DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName();
}


/*****************************************************************
 * HandleActivate
 * Delegate for the menu OnActivate event.
 *****************************************************************
 */
function HandleActivate(){
   //InitDynamicValues();
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

   //be sure to update your setting when you exit
   HandleDifficultyChange(DifficultyValue);
   HandleInvertChange(InvertLookValue);
   HandleUseSubtitlesChange(UseSubtitlesValue);
   HandleUseVibrationChange(UseVibrationValue);
   // Note: properly save to demo profile
   DOTZPlayerControllerBase(PlayerOwner()).SaveProfile();

   Controller.MouseEmulation(false);
}

/*****************************************************************
 * A Button pressed
 *****************************************************************
 */
function DoButtonA ()
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
function bool ButtonClicked(GUIComponent Sender) {
    local GUIButton Selected;

    if (GUIButton(Sender) != None) Selected = GUIButton(Sender);
    if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);



   return false;
}

/*****************************************************************
 * B Button pressed
 *
 *****************************************************************
 */
function DoButtonB ()
{
    Controller.CloseMenu(true);
}

function SetLoginName()
{
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
     NameTitleLabel=GUILabel'DOTZMenu.XDOTZProfileEditSettingsDemo.NameTitleLabel_lbl'
     Begin Object Class=GUILabel Name=InvertLookTitleLabel_lbl
         Caption="Invert Look:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.360000
         WinLeft=0.120000
         WinWidth=0.300000
         WinHeight=0.100000
         Name="InvertLookTitleLabel_lbl"
     End Object
     InvertLookTitleLabel=GUILabel'DOTZMenu.XDOTZProfileEditSettingsDemo.InvertLookTitleLabel_lbl'
     Begin Object Class=GUILabel Name=DifficultyTitleLabel_lbl
         Caption="Single Player Difficulty:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.280000
         WinLeft=0.120000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="DifficultyTitleLabel_lbl"
     End Object
     DifficultyTitleLabel=GUILabel'DOTZMenu.XDOTZProfileEditSettingsDemo.DifficultyTitleLabel_lbl'
     Begin Object Class=GUILabel Name=VibrationLabel_lbl
         Caption="Controller Vibration:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.440000
         WinLeft=0.120000
         WinWidth=0.300000
         WinHeight=0.100000
         Name="VibrationLabel_lbl"
     End Object
     UseVibrationLabel=GUILabel'DOTZMenu.XDOTZProfileEditSettingsDemo.VibrationLabel_lbl'
     Begin Object Class=GUILabel Name=NameButton_btn
         Caption="Demo Profile"
         StyleName="BBXRoundReadable"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.220000
         WinLeft=0.500000
         WinWidth=0.400000
         WinHeight=0.060000
         RenderWeight=0.900000
         Name="NameButton_btn"
     End Object
     NameButton=GUILabel'DOTZMenu.XDOTZProfileEditSettingsDemo.NameButton_btn'
     Begin Object Class=BBXSelectBox Name=InvertLookValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.380000
         WinLeft=0.480000
         WinWidth=0.400000
         WinHeight=0.060000
         TabOrder=3
         Name="InvertLookValue_lbl"
     End Object
     InvertLookValue=BBXSelectBox'DOTZMenu.XDOTZProfileEditSettingsDemo.InvertLookValue_lbl'
     Begin Object Class=BBXSelectBox Name=DifficultyValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.300000
         WinLeft=0.480000
         WinWidth=0.400000
         WinHeight=0.060000
         TabOrder=1
         bFocusOnWatch=True
         Name="DifficultyValue_lbl"
     End Object
     DifficultyValue=BBXSelectBox'DOTZMenu.XDOTZProfileEditSettingsDemo.DifficultyValue_lbl'
     Begin Object Class=BBXSelectBox Name=VibrationValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.460000
         WinLeft=0.480000
         WinWidth=0.400000
         WinHeight=0.060000
         TabOrder=4
         Name="VibrationValue_lbl"
     End Object
     UseVibrationValue=BBXSelectBox'DOTZMenu.XDOTZProfileEditSettingsDemo.VibrationValue_lbl'
     KeyboardMenu="DOTZMenu.XDOTZKeyboard"
     PageCaption="Settings"
     Normaltxt="Normal"
     Invertedtxt="Inverted"
     Easytxt="Easy"
     Hardtxt="Hard"
     Speakerstxt="Speakers"
     HeadSettxt="Xbox Communicator"
     Anonymoustxt="Anonymous"
     Ontxt="On"
     Offtxt="Off"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnActivate__Delegate=XDOTZProfileEditSettingsDemo.HandleActivate
     __OnKeyEvent__Delegate=XDOTZProfileEditSettingsDemo.HandleKeyEvent
}
