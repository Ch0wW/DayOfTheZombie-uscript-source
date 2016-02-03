// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 *
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    Sept 2003
 */
class DOTZSettingsMenuIG extends DOTZInGamePage;



//controls
var Automated GUIImage      titleLogo;
var Automated GUITabControl TabC;
var Automated GUITitleBar   TabFooter;
var Automated GUIButton     BackButton;
//var Automated GUILabel      Title;

var Automated GUIButton   BackButtonLabel;

//tab text
var localized string VideoTxt;
var localized string AudioTxt;
var localized string ControlTxt;
//var localized string GameTxt;

//tab panels
var string VideoPanel;
var string AudioPanel;
var string ControlsPanel;
//var string GamePanel;
var sound ClickSound;

var localized string PageCaption;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */
function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
   local int i;
   Super.Initcomponent(MyController, MyOwner);

   SetPageCaption(PageCaption);
   //AddBackButton();
   //AddNextButton();

   TabC.AddTab( VideoTxt,VideoPanel,,
                "" );
   TabC.AddTab( AudioTxt,AudioPanel,,
                "" );
   TabC.AddTab( ControlTxt ,ControlsPanel,,
                "" );
  // TabC.AddTab( GameTxt,GamePanel,,
  //              "Game settings" );

   for ( i = 0; i < TabC.TabStack.length; ++i ) {
      TabC.TabStack[i].Style = MyController.getStyle("BBTabButton");
   }

}


/*****************************************************************
 * Closed
 *****************************************************************
 */
 event Closed( GUIComponent Sender, bool bCancelled ) {
   Super.Closed( Sender, bCancelled );
   Controller.MouseEmulation( false );
}

/*****************************************************************
 * TabChange
 *****************************************************************
 */
function TabChange( GUIComponent Sender ) {
   if ( GUITabButton(Sender) == none ) return;
  	PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
}

/*****************************************************************
 * NotifyLevelChange
 *****************************************************************
 */
event NotifyLevelChange() {
   Controller.CloseMenu( true );
}

/*****************************************************************
 * ButtonClicked
 *****************************************************************
 */

function bool ButtonClickedBack( GUIComponent Sender ) {
    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    if (Sender == BackButtonLabel) {
        Controller.CloseMenu(true);
    }

    return true;
}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     Begin Object Class=GUITabControl Name=MyTabs
         bDockPanels=True
         TabHeight=0.050000
         bAcceptsInput=True
         WinTop=0.140000
         WinLeft=0.080000
         WinHeight=48.000000
         __OnChange__Delegate=DOTZSettingsMenuIG.TabChange
         Name="MyTabs"
     End Object
     TabC=GUITabControl'DOTZMenu.DOTZSettingsMenuIG.MyTabs'
     Begin Object Class=GUIButton Name=BackButtonLabel_lbl
         Caption="Back"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.870000
         WinLeft=0.075000
         WinWidth=0.200000
         WinHeight=0.050000
         __OnClick__Delegate=DOTZSettingsMenuIG.ButtonClickedBack
         Name="BackButtonLabel_lbl"
     End Object
     BackButtonLabel=GUIButton'DOTZMenu.DOTZSettingsMenuIG.BackButtonLabel_lbl'
     VideoTxt="Video Settings"
     AudioTxt="Audio Settings"
     ControlTxt="Control Settings"
     VideoPanel="DOTZMenu.DOTZVideoSettings"
     AudioPanel="DOTZMenu.DOTZAudioSettings"
     ControlsPanel="DOTZMenu.DOTZControlSettings"
     ClickSound=Sound'DOTZXInterface.Select'
     PageCaption="Settings"
     Begin Object Class=GUIButton Name=InGameBackground_btn
         StyleName="BBHorizontalBarSolid"
         bBoundToParent=True
         bScaleToParent=True
         bAcceptsInput=False
         bNeverFocus=True
         WinTop=0.190000
         WinLeft=0.050000
         WinWidth=0.900000
         WinHeight=0.770000
         RenderWeight=0.100000
         Name="InGameBackground_btn"
     End Object
     InGameBackground=GUIButton'DOTZMenu.DOTZSettingsMenuIG.InGameBackground_btn'
     WinTop=0.000000
     WinLeft=0.000000
     WinWidth=1.000000
     WinHeight=1.000000
}
