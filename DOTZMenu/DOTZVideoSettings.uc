// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * A one-page configuration panel, which covers coarse graphics and
 * sound settings.
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #3 $
 * @date    Oct 2003
 */
class DOTZVideoSettings extends DOTZSettingsPanel;

// graphics
var config enum EGraphicsLevel {
   DTGFX_LOW,
   DTGFX_MED,
   DTGFX_HIGH
} GraphicsDetailLevel;

// video modes
struct DisplayMode {
   var int Width;
   var int Height;
};

//gui
var Automated GUILabel    graphicsLabel;
var Automated GUIComboBox GraphicsComboBox;
var Automated GUILabel    videoLabel;
var Automated GUILabel    resolutionLabel;
var Automated GuiComboBox resolutionBox;
var Automated GuiComboBox colorDepthBox;
var localized string      BitDepthText[2];
var Automated GuiButton   videoApplyButton;
var Automated GUILabel    ShadowLabel;
var Automated GuiComboBox ShadowBox;
var Automated GUILabel    gammaLabel;
var Automated GuiSlider   gammaSlider;

// internal
var private bool bInitialized;
var localized Array<String> graphicsLevels;
var Array<DisplayMode>    DisplayModes;
var sound clickSound;

const SHADOW_LABEL = 6;
const SHADOW_BOX = 7;

struct ShadowType {
    var string label;
    var int Type;
};

var localized Array<ShadowType> ShadowTypes;

/****************************************************************
 * InitComponents
 ****************************************************************
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner) {
   local int i;
   Log( "INITCOMPONENT" );
   Super.InitComponent(MyController,MyOwner);

   for ( i = 0; i < graphicsLevels.length; ++i ) {
      GraphicsComboBox.AddItem( graphicsLevels[i] );
   }
   InternalOnLoadINI( graphicsComboBox, "INIT-GRAPHICS" );

   colorDepthBox.AddItem( BitDepthText[0] );
   colorDepthBox.AddItem( BitDepthText[1] );
   colorDepthBox.ReadOnly( true );
   CheckSupportedResolutions();

   InternalOnLoadINI( colorDepthBox, "INIT-GRAPHICS" );

   for ( i = 0; i < shadowtypes.length; i++){
      ShadowBox.AddItem( shadowtypes[i].label );
   }
   InitShadowBox( ShadowBox, "INIT-DIFFICULTY" );


   gammaSlider.SetValue(float(PlayerOwner().
         ConsoleCommand("get ini:Engine.Engine.ViewPortManager Gamma")));

   bInitialized = true;
   LOG( "END OF INIT" );
}


/****************************************************************
 * CheckSupportedResolutions
 ****************************************************************
 */
function CheckSupportedResolutions() {
   local int        Index;
   local int        BitDepth;
   local string CurrentSelection;

   CurrentSelection = resolutionBox.Edit.GetText();
   if( resolutionBox.ItemCount() > 0 ) {
      resolutionBox.RemoveItem( 0, resolutionBox.ItemCount() );
   }
   if( colorDepthBox.GetText() == BitDepthText[0] ) {
      BitDepth = 16;
   }  else {
      BitDepth = 32;
   }

   for( Index = 0; Index < DisplayModes.length; Index++ ) {
      if ( PlayerOwner().ConsoleCommand
           ( "SupportedResolution"
             @ "WIDTH="  $ DisplayModes[Index].Width
             @ "HEIGHT=" $ DisplayModes[Index].Height
             @ "BITDEPTH=" $ BitDepth ) == "1" ) {
         resolutionBox.AddItem( DisplayModes[Index].Width $ "x"
                                $ DisplayModes[Index].Height );
      }
   }
   resolutionBox.SetText( CurrentSelection );
}


/****************************************************************
 * InternalOnLoadINI
 ****************************************************************
 */
function InternalOnLoadINI(GUIComponent Sender, string s) {

   Log( "InternalOnLoadINI [" $Sender$ "] [" $s$ "]" );

   switch ( Sender ) {

   case graphicsComboBox:
      graphicsComboBox.SetText
         ( graphicsLevels[Class.default.GraphicsDetailLevel] );
      graphicsComboBox.SetIndex( Class.default.GraphicsDetailLevel );
      GraphicsChange(Sender);

   case resolutionBox:
      if( Controller.GameResolution != "" ) {
         resolutionBox.SetText( Controller.GameResolution );
      } else {
         resolutionBox.SetText( Controller.GetCurrentRes() );
      }
      CheckSupportedResolutions();


   case colorDepthBox:
      if ( PlayerOwner().ConsoleCommand("get ini:Engine.Engine.RenderDevice Use16bit") == "True" ) {
         Log("Use16bit = true" @ BitDepthText[0]);
         colorDepthBox.SetText( BitDepthText[0] );
      } else {
         Log("Use16bit = false" @ BitDepthText[1]);
         colorDepthBox.SetText( BitDepthText[1] );
      }
   } // end of switch(Sender)
}


/****************************************************************
 * SliderChange
 ****************************************************************
 */
function SliderChange(GUICOmponent Sender){

   Log ("Slider Change:" @ Sender);

   if (Sender == gammaSlider){
      PlayerOwner().
         ConsoleCommand( "set ini:Engine.Engine.ViewPortManager Gamma" @
                         GuiSlider(Sender).Value );
      Class.static.StaticSaveConfig();
   }
}


/****************************************************************
 * GraphicsChange
 ****************************************************************
 */
function GraphicsChange(GUIComponent Sender) {
   local bool changed;

   if ( !bInitialized ) return;
   changed = false;
   switch ( GraphicsComboBox.getIndex() ) {
   case 2:
      if ( GraphicsDetailLevel == DTGFX_HIGH ) break;
      SetGraphicsDetailHigh();
      changed = true;
      break;
   case 1:
      if ( GraphicsDetailLevel == DTGFX_MED ) break;
      SetGraphicsDetailMedium();
      changed = true;
      break;
   case 0:
   default:
      if ( GraphicsDetailLevel == DTGFX_LOW ) break;
      SetGraphicsDetailLow();
      changed = true;
      break;
   }

   Log( "GRAPHICS SAVE" @ Sender @ graphicsDetailLevel );
   Class.default.GraphicsDetailLevel = GraphicsDetailLevel;
   Class.static.StaticSaveConfig();
   // GraphicsDetailLevel = DTGFX_LOW;
}


/****************************************************************
 * SetGraphicsDetailHigh
 ****************************************************************
 */
function SetGraphicsDetailHigh() {
   SetTextureDetail( DTGFX_HIGH );
   PlayerOwner().ConsoleCommand
      ("set ini:Engine.Engine.RenderDevice HighDetailActors True");
   PlayerOwner().ConsoleCommand
      ("set ini:Engine.Engine.RenderDevice SuperHighDetailActors True");
   PlayerOwner().ConsoleCommand
      ("set ini:Engine.Engine.ViewportManager Coronas True");
   PlayerOwner().ConsoleCommand
      ("set ini:Engine.Engine.ViewportManager Projectors True");
   PlayerOwner().ConsoleCommand
      ("ini:Engine.Engine.ViewportManager NoDynamicLights False");
   PlayerOwner().ConsoleCommand
      ("set ini:Engine.Engine.ViewportManager DecoLayers True");
   PlayerOwner().ConsoleCommand
      ("ini:Engine.Engine.RenderDevice UseTrilinear True");
   PlayerOwner().Level.DetailChange(DM_SuperHigh);
   PlayerOwner().Level.default.PhysicsDetailLevel = PDL_High;
   PlayerOwner().Level.default.DecalStayScale = 2;
   PlayerOwner().Level.PhysicsDetailLevel
      = PlayerOwner().Level.default.PhysicsDetailLevel;
   PlayerOwner().Level.DecalStayScale
      = PlayerOwner().Level.default.DecalStayScale;
   PlayerOwner().Level.SaveConfig();
   //   PlayerOwner().ConsoleCommand
   // ("set ini:Engine.Engine.AudioDevice LowQualitySound False");
   //   PlayerOwner().ConsoleCommand("SOUND_REBOOT");
   GraphicsDetailLevel = DTGFX_HIGH;
}


/****************************************************************
 * SetGraphicsDetailMedium
 ****************************************************************
 */
function SetGraphicsDetailMedium() {
   SetTextureDetail( DTGFX_MED );
   PlayerOwner().ConsoleCommand
      ("set ini:Engine.Engine.RenderDevice HighDetailActors True");
   PlayerOwner().ConsoleCommand
      ("set ini:Engine.Engine.RenderDevice SuperHighDetailActors False");
   PlayerOwner().ConsoleCommand
      ("set ini:Engine.Engine.ViewportManager Coronas True");
   PlayerOwner().ConsoleCommand
      ("set ini:Engine.Engine.ViewportManager Projectors True");
   PlayerOwner().ConsoleCommand
      ("ini:Engine.Engine.ViewportManager NoDynamicLights False");
   PlayerOwner().ConsoleCommand
      ("set ini:Engine.Engine.ViewportManager DecoLayers True");
   PlayerOwner().ConsoleCommand
      ("ini:Engine.Engine.RenderDevice UseTrilinear False");
   PlayerOwner().Level.DetailChange(DM_High);
   PlayerOwner().Level.default.PhysicsDetailLevel = PDL_Medium;
   PlayerOwner().Level.default.DecalStayScale = 1;
   PlayerOwner().Level.PhysicsDetailLevel
      = PlayerOwner().Level.default.PhysicsDetailLevel;
   PlayerOwner().Level.DecalStayScale
      = PlayerOwner().Level.default.DecalStayScale;
   PlayerOwner().Level.SaveConfig();
   //   PlayerOwner().ConsoleCommand
   // ("set ini:Engine.Engine.AudioDevice LowQualitySound False");
   //   PlayerOwner().ConsoleCommand("SOUND_REBOOT");
   GraphicsDetailLevel = DTGFX_MED;
}


/****************************************************************
 * SetGraphicsDetailLow
 ****************************************************************
 */
function SetGraphicsDetailLow() {
   SetTextureDetail( DTGFX_LOW );
   PlayerOwner().ConsoleCommand
      ("set ini:Engine.Engine.RenderDevice HighDetailActors False");
   PlayerOwner().ConsoleCommand
      ("set ini:Engine.Engine.RenderDevice SuperHighDetailActors False");
   PlayerOwner().ConsoleCommand
      ("set ini:Engine.Engine.ViewportManager Coronas True");
   PlayerOwner().ConsoleCommand
      ("set ini:Engine.Engine.ViewportManager Projectors False");
   PlayerOwner().ConsoleCommand
      ("set ini:Engine.Engine.ViewportManager NoDynamicLights False");
   PlayerOwner().ConsoleCommand
      ("set ini:Engine.Engine.ViewportManager DecoLayers True");
   PlayerOwner().ConsoleCommand
      ("ini:Engine.Engine.RenderDevice UseTrilinear False");
   PlayerOwner().Level.DetailChange(DM_Low);
   PlayerOwner().Level.default.PhysicsDetailLevel = PDL_Low;
   PlayerOwner().Level.default.DecalStayScale = 0;
   PlayerOwner().Level.PhysicsDetailLevel
      = PlayerOwner().Level.default.PhysicsDetailLevel;
   PlayerOwner().Level.DecalStayScale
      = PlayerOwner().Level.default.DecalStayScale;
   PlayerOwner().Level.SaveConfig();
   // okay, technically this isn't a graphics thing, but it makes
   // things simpler for the user...
   // PlayerOwner().ConsoleCommand
   //  ("set ini:Engine.Engine.AudioDevice LowQualitySound True");
   // PlayerOwner().ConsoleCommand("SOUND_REBOOT");
   GraphicsDetailLevel = DTGFX_LOW;
}


/****************************************************************
 * SetTextureDetail
 ****************************************************************
 */
function SetTextureDetail( EGraphicsLevel level ) {
   local String t,v;

   Log( "Setting texture detail to" @ level );
   // figure out the command prefix and suffix...
   t = "set ini:Engine.Engine.ViewportManager TextureDetail";
   switch ( level ) {
   case DTGFX_HIGH:
      v = "UltraHigh";
      break;
   case DTGFX_MED:
      v = "Normal";
      break;
   case DTGFX_LOW:
   default:
      v = "UltraLow";
      break;
   }
   // perform the changes
   PlayerOwner().ConsoleCommand(t$"Terrain"@v);
   PlayerOwner().ConsoleCommand(t$"World"@v);
   //PlayerOwner().ConsoleCommand(t$"Rendermap"@v);
   PlayerOwner().ConsoleCommand(t$"Lightmap"@v);
   PlayerOwner().ConsoleCommand(t$"WeaponSkin"@v);
   PlayerOwner().ConsoleCommand(t$"PlayerSkin"@v);
   PlayerOwner().ConsoleCommand("flush");
}


/****************************************************************
 * UnHideVideoApply
 ****************************************************************
 */
function UnHideVideoApply( GUIComponent Sender ) {
   videoApplyButton.bVisible = true;
}


/****************************************************************
 * ApplyChanges
 ****************************************************************
 */
function bool ApplyChanges( GUIComponent Sender ) {
   local string DesiredRes;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

   DesiredRes = resolutionBox.Edit.GetText();
   if ( colorDepthBox.GetText() == BitDepthText[0] ) {
      Log( "setting to 16bit" );
      DesiredRes = DesiredRes$"x16";
   }
   else {
      Log( "setting to 32bit" );
      DesiredRes = DesiredRes$"x32";
   }
   // always play full screen
   DesiredRes = DesiredRes$"f";
   videoApplyButton.bVisible = false;
   PlayerOwner().ConsoleCommand("set ini:Engine.Engine.RenderDevice Use16bit"
                          @( InStr(DesiredRes, "x16") != -1 ));
   PlayerOwner().ConsoleCommand( "setres" @ DesiredRes );

   Log ("Desired Res" @ DesiredRes);
   Class.static.StaticSaveConfig();
   return true;
}


/****************************************************************
 * InternalOnSaveINI
 ****************************************************************
 */
function string InternalOnSaveINI(GUIComponent Sender);


/****************************************************************
 * InitDifficultyBox
 ****************************************************************
 */
function InitShadowBox(GUIComponent Sender, string s) {

    local int ID;
/*
     switch (Class'AdvancedGameInfo'.default.iUseShadows){
   case AdvancedGameInfo(Level.game).E_ShadowType.SHADOW_NONE:
  */
    switch ( Class'AdvancedGameInfo'.default.iUseShadows ) {
    case AdvancedGameInfo(PlayerOwner().Level.Game).E_ShadowType.SHADOW_NONE:
        Id = 0;
        break;
    case AdvancedGameInfo(PlayerOwner().Level.Game).E_ShadowType.SHADOW_PROJ:
        Id = 1;
        break;
    case AdvancedGameInfo(PlayerOwner().Level.Game).E_ShadowType.SHADOW_BLOB:
       Id = 2;
        break;
    //fall through to default...
    default:
        ID = 1;
    }

    ShadowBox.SetText(shadowtypes[Id].Label);
    ShadowBox.SetIndex( ID );
}

/****************************************************************
 * ShadowChange
 ****************************************************************
 */
function ShadowChange(GUIComponent Sender) {
   local int Id;

   if ( !bInitialized
        || ShadowBox.ItemCount() < shadowtypes.length )
   {
      return;
   }

   Id = GUIComboBox(Sender).getIndex();
   if ( GuiComboBox(Sender) != None) {
      SetShadowType(shadowTypes[ID].Type);
   }
}


/*****************************************************************
 * SetShadowType
 *****************************************************************
 */
function SetShadowType(int shadowtype){
    local AdvancedPawn temp;

    switch(ShadowType){
    case 0:
        class'AdvancedGameInfo'.default.iUseShadows = AdvancedGameInfo(PlayerOwner().Level.Game).E_ShadowType.SHADOW_NONE;
        break;
    case 1:
        class'AdvancedGameInfo'.default.iUseShadows = AdvancedGameInfo(PlayerOwner().Level.Game).E_ShadowType.SHADOW_PROJ;
        break;
    case 2:
        class'AdvancedGameInfo'.default.iUseShadows = AdvancedGameInfo(PlayerOwner().Level.Game).E_ShadowType.SHADOW_BLOB;
        break;
    }
    Class'AdvancedGameInfo'.static.StaticSaveConfig();

    //update the existing pawns
    foreach  PlayerOwner().allactors(class'AdvancedPawn', temp){
            temp.CheckShadow();
    }
}


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     GraphicsDetailLevel=DTGFX_HIGH
     Begin Object Class=GUILabel Name=graphics_label
         Caption="Detail level"
         TextColor=(B=119,G=243,R=248)
         TextFont="PlainGuiFont"
         WinTop=0.550000
         WinLeft=0.250000
         WinWidth=0.275000
         WinHeight=0.060000
         Name="graphics_label"
     End Object
     graphicsLabel=GUILabel'DOTZMenu.DOTZVideoSettings.graphics_label'
     Begin Object Class=BBComboBox Name=cComboBox2
         IniOption="@Internal"
         Hint="Choose how detailed the graphics are"
         WinTop=0.550000
         WinLeft=0.420000
         WinWidth=0.300000
         TabOrder=1
         __OnChange__Delegate=DOTZVideoSettings.GraphicsChange
         __OnLoadINI__Delegate=DOTZVideoSettings.InternalOnLoadINI
         __OnSaveINI__Delegate=DOTZVideoSettings.InternalOnSaveINI
         Name="cComboBox2"
     End Object
     GraphicsComboBox=BBComboBox'DOTZMenu.DOTZVideoSettings.cComboBox2'
     Begin Object Class=GUILabel Name=video_label
         Caption="Video mode"
         TextColor=(B=119,G=243,R=248)
         TextFont="PlainGuiFont"
         WinTop=0.200000
         WinLeft=0.250000
         WinWidth=0.275000
         WinHeight=0.060000
         Name="video_label"
     End Object
     videoLabel=GUILabel'DOTZMenu.DOTZVideoSettings.video_label'
     Begin Object Class=GUILabel Name=resolution_label
         Caption="Resolution"
         TextColor=(B=119,G=243,R=248)
         TextFont="PlainGuiFont"
         WinTop=0.100000
         WinLeft=0.250000
         WinWidth=0.275000
         WinHeight=0.060000
         Name="resolution_label"
     End Object
     resolutionLabel=GUILabel'DOTZMenu.DOTZVideoSettings.resolution_label'
     Begin Object Class=BBComboBox Name=VideoResolution
         IniOption="@INTERNAL"
         IniDefault="640x480"
         WinTop=0.100000
         WinLeft=0.420000
         WinWidth=0.300000
         __OnChange__Delegate=DOTZVideoSettings.UnHideVideoApply
         __OnLoadINI__Delegate=DOTZVideoSettings.InternalOnLoadINI
         __OnSaveINI__Delegate=DOTZVideoSettings.InternalOnSaveINI
         Name="VideoResolution"
     End Object
     resolutionBox=BBComboBox'DOTZMenu.DOTZVideoSettings.VideoResolution'
     Begin Object Class=BBComboBox Name=VideoColorDepth
         IniOption="@Internal"
         IniDefault="false"
         WinTop=0.200000
         WinLeft=0.420000
         WinWidth=0.300000
         __OnChange__Delegate=DOTZVideoSettings.UnHideVideoApply
         __OnLoadINI__Delegate=DOTZVideoSettings.InternalOnLoadINI
         __OnSaveINI__Delegate=DOTZVideoSettings.InternalOnSaveINI
         Name="VideoColorDepth"
     End Object
     colorDepthBox=BBComboBox'DOTZMenu.DOTZVideoSettings.VideoColorDepth'
     BitDepthText(0)="16-bit Color"
     BitDepthText(1)="32-bit Color"
     Begin Object Class=GUIButton Name=VideoApply
         Caption="Apply Video Changes"
         StyleName="BBTextButton"
         bVisible=False
         Hint="Apply all changes to your video settings."
         WinTop=0.400000
         WinLeft=0.360000
         WinWidth=0.300000
         WinHeight=0.070000
         __OnClick__Delegate=DOTZVideoSettings.ApplyChanges
         Name="VideoApply"
     End Object
     videoApplyButton=GUIButton'DOTZMenu.DOTZVideoSettings.VideoApply'
     Begin Object Class=GUILabel Name=shadow_label1
         Caption="Shadows"
         TextColor=(B=119,G=243,R=248)
         TextFont="PlainGuiFont"
         WinTop=0.650000
         WinLeft=0.250000
         WinWidth=0.300000
         WinHeight=0.050000
         Name="shadow_label1"
     End Object
     ShadowLabel=GUILabel'DOTZMenu.DOTZVideoSettings.shadow_label1'
     Begin Object Class=BBComboBox Name=cComboBox7
         IniOption="@Internal"
         IniDefault="High Detail"
         StyleName="BBTextButton"
         Hint="Choose how difficult the game is"
         WinTop=0.650000
         WinLeft=0.420000
         WinWidth=0.300000
         TabOrder=4
         __OnChange__Delegate=DOTZVideoSettings.ShadowChange
         __OnLoadINI__Delegate=DOTZVideoSettings.InitShadowBox
         __OnSaveINI__Delegate=DOTZVideoSettings.InternalOnSaveINI
         Name="cComboBox7"
     End Object
     ShadowBox=BBComboBox'DOTZMenu.DOTZVideoSettings.cComboBox7'
     Begin Object Class=GUILabel Name=gamma_label
         Caption="Gamma level"
         TextColor=(B=119,G=243,R=248)
         TextFont="PlainGuiFont"
         WinTop=0.300000
         WinLeft=0.250000
         WinWidth=0.275000
         WinHeight=0.060000
         Name="gamma_label"
     End Object
     gammaLabel=GUILabel'DOTZMenu.DOTZVideoSettings.gamma_label'
     Begin Object Class=BBGuiSlider Name=gamma_slider
         MaxValue=2.500000
         IniOption="ini:Engine.Engine.ViewPortManager Gamma"
         IniDefault="1"
         Hint="Changes the gamma for the game."
         WinTop=0.305000
         WinLeft=0.410000
         __OnChange__Delegate=DOTZVideoSettings.SliderChange
         Name="gamma_slider"
     End Object
     gammaSlider=BBGuiSlider'DOTZMenu.DOTZVideoSettings.gamma_slider'
     graphicsLevels(0)="Low detail: best speed"
     graphicsLevels(1)="Medium detail"
     graphicsLevels(2)="High detail: best quality"
     DisplayModes(0)=(Width=640,Height=480)
     DisplayModes(1)=(Width=800,Height=500)
     DisplayModes(2)=(Width=800,Height=600)
     DisplayModes(3)=(Width=1024,Height=640)
     DisplayModes(4)=(Width=1024,Height=768)
     DisplayModes(5)=(Width=1152,Height=864)
     DisplayModes(6)=(Width=1280,Height=800)
     DisplayModes(7)=(Width=1280,Height=960)
     DisplayModes(8)=(Width=1280,Height=1024)
     DisplayModes(9)=(Width=1600,Height=1200)
     DisplayModes(10)=(Width=1440,Height=900)
     DisplayModes(11)=(Width=1680,Height=1050)
     ClickSound=Sound'DOTZXInterface.Select'
     ShadowTypes(0)=(Label="None")
     ShadowTypes(1)=(Label="High Detail",Type=1)
     ShadowTypes(2)=(Label="Low Detail",Type=2)
     WinTop=55.980499
     WinHeight=0.807813
}
