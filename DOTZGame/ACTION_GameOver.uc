// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*
 * This will only work in a single player game type
*/
class ACTION_GameOver extends ScriptedAction;

var(Action) string SpectatingMessage;
var(Action) name ViewActorTag;

function bool InitActionFor(ScriptedController C)
{
   local PlayerController pc;
   local Actor temp;
   local AdvancedGameInfo g;

   // Disable saving
   g = AdvancedGameInfo( C.Level.Game );
   if ( g != none )
    g.bDisableSave = true;

   pc = C.Level.GetLocalPlayerController();
   AdvancedGameInfo(C.Level.Game).SpectatingMsg = SpectatingMessage;
   foreach pc.AllActors(class'Actor', temp, ViewActorTag){
      pc.SetViewTarget(temp);
      break;
   }
   pc.GotoState('Spectating');
   return true;
}

defaultproperties
{
     SpectatingMessage="Game Over. Press START to continue."
     ViewActorTag="'"
}
