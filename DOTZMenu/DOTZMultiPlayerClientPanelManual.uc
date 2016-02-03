// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DotzMultiPlayerBase
 *
 * Intended to be a base class to organize all multiplayer related menus
 *
 * @author  Jesse LaChapelle (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    July 2004
 */
class DOTZMultiPlayerClientPanelManual extends DOTZMultiPlayerClientPanel;



//Controls
var Automated GuiLabel        IPLabel;
var Automated BBEditBox       IPValue;
var Automated GUIButton       NextButtonLabel;


var bool accept_input;
var float period;

//var Automated GuiButton  CreateMatchButton;
var localized string PageCaption;


/*****************************************************************
 * InitComponent
 *****************************************************************
 */
function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
   Super.Initcomponent(MyController, MyOwner);
   NextButtonLabel.OnClick=OnNext;
}


/*****************************************************************
 * Next Button
 *****************************************************************
 */
function bool OnNext( GUIComponent Sender ) {

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    if (IPValue.GetText() == "") {
        Controller.OpenMenu("DOTZMenu.DOTZEmptyIP");
    } else {
        //password prompt is always required for clients manually connecting to lan games
        Controller.OpenMenu("DOTZMenu.DOTZCharacterSelect", IPValue.GetText(), "true");
    }
    return true;
}



//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     Begin Object Class=GUILabel Name=IPLabel_lbl
         Caption="Connect to host IP:"
         TextFont="PlainGuiFont"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.100000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="IPLabel_lbl"
     End Object
     IPLabel=GUILabel'DOTZMenu.DOTZMultiPlayerClientPanelManual.IPLabel_lbl'
     Begin Object Class=BBEditBox Name=IPValue_lbl
         AllowedCharSet="1234567890."
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.110000
         WinLeft=0.450000
         WinWidth=0.400000
         WinHeight=0.060000
         Name="IPValue_lbl"
     End Object
     IPValue=BBEditBox'DOTZMenu.DOTZMultiPlayerClientPanelManual.IPValue_lbl'
     Begin Object Class=GUIButton Name=NextButtonLabel_lbl
         Caption="Next"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.750000
         WinLeft=0.700000
         WinWidth=0.150000
         WinHeight=0.050000
         Name="NextButtonLabel_lbl"
     End Object
     NextButtonLabel=GUIButton'DOTZMenu.DOTZMultiPlayerClientPanelManual.NextButtonLabel_lbl'
     PageCaption="Multiplayer Join"
}
