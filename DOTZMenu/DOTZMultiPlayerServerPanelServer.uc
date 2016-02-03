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
class DOTZMultiPlayerServerPanelServer extends DOTZMultiPlayerPanel;



var sound ClickSound;


/****************************************************************
 * InitComponent
 ****************************************************************
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner) {
    super.InitComponent(MyController, MyOwner);
}


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     Controls(0)=GUILabel'DOTZMenu.DOTZMultiPlayerServerPanelServer.ServerNameTitleLabel_lbl'
     Controls(1)=BBEditBox'DOTZMenu.DOTZMultiPlayerServerPanelServer.ServerName_lbl'
     Controls(2)=GUILabel'DOTZMenu.DOTZMultiPlayerServerPanelServer.NetworkLabel_lbl'
     Controls(3)=BBComboBox'DOTZMenu.DOTZMultiPlayerServerPanelServer.NetworkValue_lbl'
     Controls(4)=GUILabel'DOTZMenu.DOTZMultiPlayerServerPanelServer.ReqPasswordLabel_lbl'
     Controls(5)=BBCheckBoxButton'DOTZMenu.DOTZMultiPlayerServerPanelServer.ReqPassword_box1'
     Controls(6)=GUILabel'DOTZMenu.DOTZMultiPlayerServerPanelServer.ServerPasswordLabel_lbl'
     Controls(7)=BBEditBox'DOTZMenu.DOTZMultiPlayerServerPanelServer.ServerPassword_lbl'
     WinTop=55.980499
     WinHeight=0.807813
}
