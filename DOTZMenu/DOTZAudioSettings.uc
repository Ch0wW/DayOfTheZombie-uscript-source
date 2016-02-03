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
class DOTZAudioSettings extends DOTZSettingsPanel;

// audio
var Automated GUILabel      musicVolumeLabel;
var Automated GuiSlider     musicVolumeSlider;
var Automated GUILabel      effectsVolumeLabel;
var Automated GuiSlider     effectsVolumeSlider;
var Automated moCheckBox    reverseStereoCheck;
var Automated GUILabel      audioModeLabel;
var Automated GUIComboBox   audioModesBox;
var localized string        AudioModes[2];
var private String          currentAudioMode;

// internal
var private bool bInitialized;
var sound ClickSound;

/*****************************************************************
 * InitComponents
 *****************************************************************
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner) {

   local int i;
   local float curVal;
   Super.InitComponent(MyController,MyOwner);

   //set effects volume slider
   curVal = float(PlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice SoundVolume"));
   effectsVolumeSlider.SetValue( curVal );

   //set the music slider
   curVal = float(PlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice MusicVolume"));
   musicVolumeSlider.SetValue( curVal );

   //fill the audio drop down with available modes
   for ( i = 0; i < ArrayCount(AudioModes); ++i ) {
      audioModesBox.AddItem( AudioModes[i] );
   }
   InitAudioBox(audioModesBox, "");
   bInitialized = true;
}

/*****************************************************************
 * InternalOnLoadIni
 *****************************************************************
 */

function InitAudioBox(GUIComponent Sender, string s) {

   local bool bUse3D, bCompMode;

   bCompMode = bool( PlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice CompatibilityMode") );
   bUse3D = bool( PlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice Use3DSound") );

   if ( bCompMode == true){
    AudioModesBox.SetText( AudioModes[1] );

   } else if ( bUse3D ==true) {
    AudioModesBox.SetText( AudioModes[0] );

   } else {
    AudioModesBox.SetText( AudioModes[0] );
   }
   currentAudioMode = AudioModesBox.GetText();
}


/*****************************************************************
 * VolumeChange
 *****************************************************************
 */
function volumeChange( GUIComponent Sender ) {
   local String channel;

   //determine which slider changed
   if ( Sender == musicVolumeSlider ) {
    channel = "MusicVolume";
   } else if ( Sender == effectsVolumeSlider ){
    channel = "SoundVolume";
   } else {
     Log( "unknown component" @ sender );
     return;
   }

   Log("Volume slider value: " $ GuiSlider(Sender).Value);

   PlayerOwner().ConsoleCommand( "set ini:Engine.Engine.AudioDevice"
                                 @ channel @ GuiSlider(Sender).Value );
   PlayerOwner().ConsoleCommand("stopsounds");

   // restart the music at the new volume
   if ( Sender == musicVolumeSlider ) {
      restartLevelMusic();
   }

}


/*****************************************************************
 * RestartLevelMusic
 *****************************************************************
 */
function restartLevelMusic() {
   // Restart music.
   PlayerOwner().StopAllMusic( 0 );
   if (PlayerOwner().Level.Song != "" && PlayerOwner().Level.Song != "None") {
      PlayerOwner().ClientSetMusic( PlayerOwner().Level.Song, MTRAN_Instant );
   }
}


/*****************************************************************
 * AudioModeChange
 *****************************************************************
 */
function AudioModeChange( GUIComponent Sender ) {
   local String t;

   t = audioModesBox.GetText();
   if ( !bInitialized || t == currentAudioMode ) return;
   Log ("changing the audio mode because " $ currentAudioMode $ "  " $ bInitialized);

   //3D AUDIO
   if ( t == AudioModes[0] ) {
      PlayerOwner().ConsoleCommand
         ("set ini:Engine.Engine.AudioDevice Use3DSound true" );
      PlayerOwner().ConsoleCommand
         ("set ini:Engine.Engine.AudioDevice CompatibilityMode false" );
   }
   //Safe Mode
   else if ( t == AudioModes[1] ) {
      PlayerOwner().ConsoleCommand
         ("set ini:Engine.Engine.AudioDevice Use3DSound false" );
      PlayerOwner().ConsoleCommand
         ("set ini:Engine.Engine.AudioDevice CompatibilityMode true" );
   }
   PlayerOwner().ConsoleCommand("SOUND_REBOOT");
   currentAudioMode = AudioModesBox.GetText();
   restartLevelMusic();
}


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     Begin Object Class=GUILabel Name=AudioMusicVolumeLabel
         Caption="Music Volume"
         TextColor=(B=119,G=243,R=248)
         TextFont="PlainGuiFont"
         WinTop=0.150000
         WinLeft=0.250000
         WinWidth=0.250000
         WinHeight=0.060000
         Name="AudioMusicVolumeLabel"
     End Object
     musicVolumeLabel=GUILabel'DOTZMenu.DOTZAudioSettings.AudioMusicVolumeLabel'
     Begin Object Class=BBGuiSlider Name=AudioMusicVolumeSlider
         MaxValue=1.000000
         IniOption="ini:Engine.Engine.AudioDevice MusicVolume"
         IniDefault="0.5"
         Hint="Changes the volume of the background music."
         WinTop=0.150000
         WinLeft=0.410000
         __OnChange__Delegate=DOTZAudioSettings.volumeChange
         Name="AudioMusicVolumeSlider"
     End Object
     musicVolumeSlider=BBGuiSlider'DOTZMenu.DOTZAudioSettings.AudioMusicVolumeSlider'
     Begin Object Class=GUILabel Name=AudioEffectsVolumeLabel
         Caption="Effects Volume"
         TextColor=(B=119,G=243,R=248)
         TextFont="PlainGuiFont"
         WinTop=0.275000
         WinLeft=0.250000
         WinWidth=0.250000
         WinHeight=0.060000
         Name="AudioEffectsVolumeLabel"
     End Object
     effectsVolumeLabel=GUILabel'DOTZMenu.DOTZAudioSettings.AudioEffectsVolumeLabel'
     Begin Object Class=BBGuiSlider Name=AudioEffectsVolumeSlider
         MaxValue=1.000000
         IniOption="ini:Engine.Engine.AudioDevice SoundVolume"
         IniDefault="0.9"
         Hint="Changes the volume of all in game sound effects."
         WinTop=0.275000
         WinLeft=0.410000
         __OnChange__Delegate=DOTZAudioSettings.volumeChange
         Name="AudioEffectsVolumeSlider"
     End Object
     effectsVolumeSlider=BBGuiSlider'DOTZMenu.DOTZAudioSettings.AudioEffectsVolumeSlider'
     Begin Object Class=GUILabel Name=audiomode_label
         Caption="Audio mode"
         TextColor=(B=119,G=243,R=248)
         TextFont="PlainGuiFont"
         WinTop=0.400000
         WinLeft=0.250000
         WinWidth=0.300000
         WinHeight=0.060000
         Name="audiomode_label"
     End Object
     audioModeLabel=GUILabel'DOTZMenu.DOTZAudioSettings.audiomode_label'
     Begin Object Class=BBComboBox Name=AudioMode_cbox
         IniOption="@Internal"
         IniDefault="Software 3D Audio"
         StyleName="BBRoundButton"
         Hint="Changes the audio system mode."
         WinTop=0.400000
         WinLeft=0.420000
         WinWidth=0.300000
         __OnChange__Delegate=DOTZAudioSettings.AudioModeChange
         __OnLoadINI__Delegate=DOTZAudioSettings.InitAudioBox
         Name="AudioMode_cbox"
     End Object
     audioModesBox=BBComboBox'DOTZMenu.DOTZAudioSettings.AudioMode_cbox'
     AudioModes(0)="Software 3D Audio"
     AudioModes(1)="Safe Mode"
     ClickSound=Sound'DOTZXInterface.Select'
     WinTop=55.980499
     WinHeight=0.807813
}
