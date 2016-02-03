// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZMainMenu - the main menu for Xbox DOTZ, based on the Warfare
 *              "GUI" package.
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZOptionsIGSP extends XDOTZInGamePage;



//Page components
var Automated GuiLabel   InvertLookTitleLabel;
var Automated GuiLabel   UseSubtitlesLabel;
var Automated GuiLabel   UseVibrationLabel;
var Automated GuiLabel   ControllerSensitivityLabel;

var Automated BBXSelectBox   InvertLookValue;
var Automated BBXSelectBox   UseSubtitlesValue;
var Automated BBXSelectBox   UseVibrationValue;
var Automated BBXSelectBox   ControllerSensitivityValue;

// Configurable
var string KeyboardMenu;         // Profile menu location

//configurable stuff
var localized string PageCaption;

var localized string Normaltxt;
var localized string Invertedtxt;
var localized string Easytxt;
var localized string Hardtxt;
var localized string Ontxt;
var localized string Offtxt;

var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
   Super.Initcomponent(MyController, MyOwner);
   // init my components...

   SetPageCaption (PageCaption);
   AddBackButton ();
   AddSaveButton();

   // Make sure values are all loaded
   //DOTZPlayerControllerBase(PlayerOwner()).SetProfileConfiguration();

   InvertLookValue.AddItem(Normaltxt);
   InvertLookValue.AddItem(Invertedtxt);
   InvertLookValue.SetIndex(int(DOTZPlayerControllerBase(PlayerOwner()).GetInvertLook()));

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


   SetFocus(UseSubtitlesValue);
   UseSubtitlesValue.SetFocus(none);
}


/*****************************************************************
 * HandleActivate
 * Delegate for the menu OnActivate event.
 *****************************************************************
 */
function HandleActivate(){


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
    Controller.CloseMenu(true);
}

/*****************************************************************
 * X Button pressed
 *****************************************************************
 */
function DoButtonA ()
{
   //be sure to update your setting when you exit
    HandleInvertChange(InvertLookValue);
    HandleUseSubtitlesChange(UseSubtitlesValue);
    HandleUseVibrationChange(UseVibrationValue);
    HandleControllerSensitivityChange(ControllerSensitivityValue);

    DOTZPlayerControllerBase(PlayerOwner()).SaveProfile();

    CloseMenu ();
}

/*****************************************************************
 * X Button pressed
 *****************************************************************
 */
function DoButtonB ()
{
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

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     Begin Object Class=GUILabel Name=InvertLookTitleLabel_lbl
         Caption="Invert Look:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.300000
         WinLeft=0.075000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="InvertLookTitleLabel_lbl"
     End Object
     InvertLookTitleLabel=GUILabel'DOTZMenu.XDOTZOptionsIGSP.InvertLookTitleLabel_lbl'
     Begin Object Class=GUILabel Name=UseSubtitlesLabel_lbl
         Caption="Subtitles:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.200000
         WinLeft=0.075000
         WinWidth=0.300000
         WinHeight=0.100000
         Name="UseSubtitlesLabel_lbl"
     End Object
     UseSubtitlesLabel=GUILabel'DOTZMenu.XDOTZOptionsIGSP.UseSubtitlesLabel_lbl'
     Begin Object Class=GUILabel Name=VibrationLabel_lbl
         Caption="Controller Vibration:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.400000
         WinLeft=0.075000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="VibrationLabel_lbl"
     End Object
     UseVibrationLabel=GUILabel'DOTZMenu.XDOTZOptionsIGSP.VibrationLabel_lbl'
     Begin Object Class=GUILabel Name=ControllerSensitivityLabel_lbl
         Caption="Controller Sensitivity:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.500000
         WinLeft=0.075000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="ControllerSensitivityLabel_lbl"
     End Object
     ControllerSensitivityLabel=GUILabel'DOTZMenu.XDOTZOptionsIGSP.ControllerSensitivityLabel_lbl'
     Begin Object Class=BBXSelectBox Name=InvertLookValue_lbl
         StyleName="BBXSquareButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.320000
         WinLeft=0.480000
         WinWidth=0.475000
         WinHeight=0.090000
         Name="InvertLookValue_lbl"
     End Object
     InvertLookValue=BBXSelectBox'DOTZMenu.XDOTZOptionsIGSP.InvertLookValue_lbl'
     Begin Object Class=BBXSelectBox Name=UseSubtitlesValue_lbl
         StyleName="BBXSquareButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.220000
         WinLeft=0.480000
         WinWidth=0.475000
         WinHeight=0.090000
         Name="UseSubtitlesValue_lbl"
     End Object
     UseSubtitlesValue=BBXSelectBox'DOTZMenu.XDOTZOptionsIGSP.UseSubtitlesValue_lbl'
     Begin Object Class=BBXSelectBox Name=VibrationValue_lbl
         StyleName="BBXSquareButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.420000
         WinLeft=0.480000
         WinWidth=0.475000
         WinHeight=0.090000
         Name="VibrationValue_lbl"
     End Object
     UseVibrationValue=BBXSelectBox'DOTZMenu.XDOTZOptionsIGSP.VibrationValue_lbl'
     Begin Object Class=BBXSelectBox Name=ControllerSensitivityValue_lbl
         StyleName="BBXSquareButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.520000
         WinLeft=0.480000
         WinWidth=0.475000
         WinHeight=0.090000
         Name="ControllerSensitivityValue_lbl"
     End Object
     ControllerSensitivityValue=BBXSelectBox'DOTZMenu.XDOTZOptionsIGSP.ControllerSensitivityValue_lbl'
     KeyboardMenu="DOTZMenu.XDOTZKeyboard"
     PageCaption="Settings"
     Normaltxt="Normal"
     Invertedtxt="Inverted"
     Easytxt="Easy"
     Hardtxt="Hard"
     Ontxt="On"
     Offtxt="Off"
     ClickSound=Sound'DOTZXInterface.Select'
     WinTop=0.200000
     WinHeight=0.600000
     __OnKeyEvent__Delegate=XDOTZOptionsIGSP.HandleKeyEvent
}
