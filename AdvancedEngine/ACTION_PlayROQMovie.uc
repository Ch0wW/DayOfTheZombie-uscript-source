// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * Author : Jesse LaChapelle
 * Date : Sept 20, 2004
 * Description : An action that allows LD's to specify a cutscene
 * video from a script
 *****************************************************************
 */
class ACTION_PlayROQMovie extends ScriptedAction;

var(Action)     string          VideoName;
var(Action)     sound           SoundFile;
var(Action)     bool            bLoop;
var(Action)     float           ScaleX;
var(Action)     float           ScaleY;

/****************************************************************
 * InitActionsFor
 ****************************************************************
 */
function bool InitActionFor( ScriptedController c ) {

  AdvancedPlayerController(c.Level.GetLocalPlayerController()).PlayMovie(VideoName, bLoop, SoundFile,ScaleX,ScaleY);
  return false;

}
function string GetActionString()
{
    return ActionString;
}

defaultproperties
{
     VideoName="SomeMovie.RoQ"
     scaleX=1.000000
     scaleY=0.870000
     ActionString="Play ROQ"
}
