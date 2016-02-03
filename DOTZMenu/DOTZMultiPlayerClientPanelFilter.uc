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
class DOTZMultiPlayerClientPanelFilter extends DOTZMultiPlayerClientPanel;



// internal
var private bool bInitialized;
var sound ClickSound;

const FILTER_GAMETYPE = 0;
const FILTER_FULLSERVER = 2;
const FILTER_PASSWORD = 4;

//persistant storage related to the server panel
var config bool bNoPassword;
var config bool bNoFull;

var localized string AnyTxt;
var localized string DMTxt;
var localized string CTFTxt;
var localized string INVTxt;

/****************************************************************
 * InitComponent
 ****************************************************************
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner) {

   Super.InitComponent(MyController,MyOwner);

   //gametype box
   BBComboBox(Controls[FILTER_GAMETYPE]).AddItem(AnyTxt,,"");
   BBComboBox(Controls[FILTER_GAMETYPE]).AddItem(DMTxt,,"DOTZDeathMatch");
   BBComboBox(Controls[FILTER_GAMETYPE]).AddItem(CTFTxt,,"DOTZCaptureTheFl");
   BBComboBox(Controls[FILTER_GAMETYPE]).AddItem(INVTxt,,"DOTZInvasion");

   //full server check box
   if (self.default.bNoFull == true){
      moCheckBox(Controls[FILTER_FULLSERVER]).Checked(true);
      moCheckBox(Controls[FILTER_FULLSERVER]).bChecked = true;
   }

   //password filter check box
   if (self.default.bNoPassword == true){
      moCheckBox(Controls[FILTER_PASSWORD]).Checked(true);  //state of the graphic
      moCheckBox(Controls[FILTER_PASSWORD]).bChecked = true; // state of the component
   }

   bInitialized = true;
}


/*****************************************************************
 * OnCloseBrowser
 *****************************************************************
 */
function OnCloseBrowser(){
   super.OnCloseBrowser();
   default.bNoFull     = moCheckBox(Controls[FILTER_FULLSERVER]).IsChecked();
   default.bNoPassword = moCheckBox(Controls[FILTER_PASSWORD]).IsChecked();
   self.static.StaticSaveConfig();
}


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     AnyTxt="Any"
     DMTxt="DeathMatch/Team Deathmatch"
     CTFTxt="Capture the Flag"
     INVTxt="Invasion"
     Controls(0)=BBComboBox'DOTZMenu.DOTZMultiPlayerClientPanelFilter.matchtype_cbox'
     Controls(1)=GUILabel'DOTZMenu.DOTZMultiPlayerClientPanelFilter.GameType_lbl'
     Controls(2)=moCheckBox'DOTZMenu.DOTZMultiPlayerClientPanelFilter.FullServers_check'
     Controls(3)=GUILabel'DOTZMenu.DOTZMultiPlayerClientPanelFilter.FullServer_lbl'
     Controls(4)=moCheckBox'DOTZMenu.DOTZMultiPlayerClientPanelFilter.Password_check'
     Controls(5)=GUILabel'DOTZMenu.DOTZMultiPlayerClientPanelFilter.Password_lbl'
}
