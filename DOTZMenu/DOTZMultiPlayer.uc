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
class DOTZMultiPlayer extends DOTZMultiPlayerBase;



//Controls
var Automated GuiLabel        IPLabel;
var Automated BBEditBox       IPValue;

var sound clickSound;

//var Automated GuiButton  CreateMatchButton;
var localized string PageCaption;


/*****************************************************************
 * InitComponent
 *****************************************************************
 */
function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
   Super.Initcomponent(MyController, MyOwner);

   SetPageCaption(PageCaption);
   AddBackButton();
   AddNextButton();
}

/*****************************************************************
 * Next Button
 *****************************************************************
 */

function Click_Next ()
{
    Controller.OpenMenu("DOTZMenu.DOTZCharacterSelect", IPValue.GetText()
            //$ "?XGAMERTAG=" $ EncodeStringURL(class'UtilsXbox'.static.Get_Current_Name())
            //$ "?XUID=" $ class'UtilsXbox'.static.Get_Current_ID()
            //$ "?XNADDR=" $ class'UtilsXbox'.static.Get_Current_Address()
        );

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
         WinTop=0.400000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="IPLabel_lbl"
     End Object
     IPLabel=GUILabel'DOTZMenu.DOTZMultiPlayer.IPLabel_lbl'
     Begin Object Class=BBEditBox Name=IPValue_lbl
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.410000
         WinLeft=0.450000
         WinWidth=0.400000
         WinHeight=0.060000
         Name="IPValue_lbl"
     End Object
     IPValue=BBEditBox'DOTZMenu.DOTZMultiPlayer.IPValue_lbl'
     ClickSound=Sound'DOTZXInterface.Select'
     PageCaption="Multiplayer Join"
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     RenderWeight=0.100000
     __OnKeyEvent__Delegate=DOTZMultiPlayer.HandleKeyEvent
}
