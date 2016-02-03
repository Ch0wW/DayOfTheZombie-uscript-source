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
class DOTZMultiPlayerServerPanelGame extends DOTZMultiPlayerPanel;



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
     Controls(0)=GUILabel'DOTZMenu.DOTZMultiPlayerServerPanelGame.TimeLimitTitleLabel_lbl'
     Controls(1)=BBComboBox'DOTZMenu.DOTZMultiPlayerServerPanelGame.TimeLimitValue_lbl'
     Controls(2)=GUILabel'DOTZMenu.DOTZMultiPlayerServerPanelGame.ScoreLimitTitleLabel_lbl'
     Controls(3)=BBComboBox'DOTZMenu.DOTZMultiPlayerServerPanelGame.ScoreLimitValue_lbl'
     Controls(4)=GUILabel'DOTZMenu.DOTZMultiPlayerServerPanelGame.MaxPlayersTitleLabel_lbl'
     Controls(5)=BBComboBox'DOTZMenu.DOTZMultiPlayerServerPanelGame.MaxPlayersValue_lbl'
     Controls(6)=GUILabel'DOTZMenu.DOTZMultiPlayerServerPanelGame.EnemyStrengthLabel_lbl'
     Controls(7)=BBComboBox'DOTZMenu.DOTZMultiPlayerServerPanelGame.EnemyStrengthValue_lbl'
     Controls(8)=GUILabel'DOTZMenu.DOTZMultiPlayerServerPanelGame.FriendlyFireTitleLabel_lbl'
     Controls(9)=BBComboBox'DOTZMenu.DOTZMultiPlayerServerPanelGame.FriendlyFireValue_lbl'
     WinTop=55.980499
     WinHeight=0.807813
}
