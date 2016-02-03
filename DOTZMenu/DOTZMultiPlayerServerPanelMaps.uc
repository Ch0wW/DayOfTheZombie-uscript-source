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
class DOTZMultiPlayerServerPanelMaps extends DOTZMultiPlayerPanel;



var sound ClickSound;


/****************************************************************
 * InitComponent
 ****************************************************************
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner) {
    super.InitComponent(MyController, MyOwner);
}

//===========================================================================
// defaultproperties
//===========================================================================

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     Controls(0)=GUILabel'DOTZMenu.DOTZMultiPlayerServerPanelMaps.GametypeTitleLabel_lbl'
     Controls(1)=BBComboBox'DOTZMenu.DOTZMultiPlayerServerPanelMaps.GametypeValue_lbl'
     Controls(2)=GUILabel'DOTZMenu.DOTZMultiPlayerServerPanelMaps.List2_lbl'
     Controls(3)=GUILabel'DOTZMenu.DOTZMultiPlayerServerPanelMaps.List1_lbl'
     Controls(4)=BBListBox'DOTZMenu.DOTZMultiPlayerServerPanelMaps.AllMaps'
     Controls(5)=BBListBox'DOTZMenu.DOTZMultiPlayerServerPanelMaps.SelectedMaps'
     Controls(7)=GUIButton'DOTZMenu.DOTZMultiPlayerServerPanelMaps.Map_Up'
     Controls(8)=GUIButton'DOTZMenu.DOTZMultiPlayerServerPanelMaps.Map_Add'
     Controls(9)=GUIButton'DOTZMenu.DOTZMultiPlayerServerPanelMaps.Map_AddAll'
     Controls(10)=GUIButton'DOTZMenu.DOTZMultiPlayerServerPanelMaps.Map_Remove'
     Controls(11)=GUIButton'DOTZMenu.DOTZMultiPlayerServerPanelMaps.Map_RemoveAll'
     Controls(12)=GUIButton'DOTZMenu.DOTZMultiPlayerServerPanelMaps.Map_Down'
     WinTop=55.980499
     WinHeight=0.807813
}
