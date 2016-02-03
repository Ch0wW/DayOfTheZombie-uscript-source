// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DOTZSettingsPanel extends GUITabPanel;

/*****************************************************************
 * ShowPanel
 *****************************************************************
 */
function ShowPanel(bool bShow){
    local int c;

    Super.ShowPanel(bShow);

    for (c = 0; c < Controls.Length; ++c)
        Controls[c].SetVisibility(bShow);
}

defaultproperties
{
}
