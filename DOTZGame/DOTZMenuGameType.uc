// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZMenuGameType -
 *
 * @version $1.0$
 * @author  Jesse Lachapelle (jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Nov 2003
 */
class DOTZMenuGameType extends DOTZGameInfoBase;

//===========================================================================
// GameInfo hooks
//===========================================================================

/**
 * Initialize the game.  The GameInfo's InitGame() function is called
 * before any other scripts (including PreBeginPlay() ), and is used
 * by the GameInfo to initialize parameters and spawn its helper
 * classes.  Warning: this is called before actors' PreBeginPlay.
 */
event InitGame( String options, out String error ) {
   //Level.NetMode = NM_StandAlone;
   super.InitGame( options, error );
}


/**
 */
function PostBeginPlay(){
    super.PostBeginPlay();
}

/**
 * Start the game - inform all actors that the match is starting, and
 * spawn player pawns.
 */
function PostLogin( PlayerController newPlayer ) {
    super.PostLogin( newPlayer );
}

/*
 * Called whenever a player needs to be spawned.
 */
function RestartPlayer( Controller c ) {
   super.RestartPlayer( c );
}

/**
 * Normally notifies all players (AI and human) when someone dies.
 * This does not include other NPCs, so this version ensures that all
 * of the AI opponents are notified.
 */
function NotifyKilled(Controller killer, Controller killed, Pawn killedPawn) {
   Super.NotifyKilled( killer, killed, killedPawn );
}

/**
 * Called when a player leaves the level.
 */
function Logout( Controller Exiting ) {
    super.logout( exiting );
}

function bool SetPause( bool bPause, PlayerController pc ) {
   if (AdvancedPlayerController(pc).objVideoPlayer.VideoIsPlaying() )
   {
        if (AdvancedPlayerController(pc).objVideoPlayer.VideoIsPlaying() && bPause == false){
            AdvancedPlayerController(pc).objVideoPlayer.StopVideo();
        }
        return super.SetPause(bPause,pc);
   } else {
      Level.Pauser=None;
        return True;
   }
}

/******************************************************************
 * TestEvent
 * Triggers the specified event.  Handy for debugging.
 ******************************************************************
 */
exec function TestEvent( Name eventName ) {
    Log( "Triggering [" $ eventName $ "]" );
    TriggerEvent( eventName, self, none );
}


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     PreloadObjects(0)="DOTZEngine.SkelHead"
     PreloadObjects(1)="DOTZMenu.XDOTZSPPause"
     PreloadMesh(0)=StaticMesh'DOTZSSpecial.Particles.Rock'
     PreloadMesh(1)=StaticMesh'DOTZSSpecial.Particles.Barrelpiece'
     PreloadMesh(2)=StaticMesh'DOTZSSpecial.Particles.splash'
     PreloadMesh(3)=StaticMesh'DOTZSSpecial.Particles.Woodshard'
     PreloadMesh(4)=StaticMesh'DOTZSSpecial.Particles.Concrete'
     PreloadMesh(5)=StaticMesh'DOTZSSpecial.Gore.BloodyChunk'
     PreloadMesh(6)=StaticMesh'DOTZSSpecial.GibForearm.GibForearmA'
     PreloadMesh(7)=StaticMesh'DOTZSSpecial.GibForearm.GibForearmB'
     PreloadMesh(8)=StaticMesh'DOTZSSpecial.GibForearm.GibForearmC'
     PreloadMesh(9)=StaticMesh'DOTZSSpecial.GibForearm.GibForearmD'
     PreloadMesh(10)=StaticMesh'DOTZSSpecial.GibUpperArm.UpperArmA'
     PreloadMesh(11)=StaticMesh'DOTZSSpecial.GibUpperArm.UpperArmB'
     PreloadMesh(12)=StaticMesh'DOTZSSpecial.GibUpperArm.UpperArmC'
     PreloadMesh(13)=StaticMesh'DOTZSSpecial.GibUpperArm.UpperArmD'
     PreloadMesh(14)=StaticMesh'DOTZSSpecial.GibUpperArm.UpperArmE'
     PreloadMesh(15)=StaticMesh'DOTZSSpecial.GibLeg.GibLegA'
     PreloadMesh(16)=StaticMesh'DOTZSSpecial.GibLeg.GibLegB'
     PreloadMesh(17)=StaticMesh'DOTZSSpecial.GibLeg.GibLegC'
     PreloadMesh(18)=StaticMesh'DOTZSSpecial.GibLeg.GibLegD'
     PreloadMesh(19)=StaticMesh'DOTZSSpecial.GibLeg.GibLegE'
     PreloadMaterial(3)=Texture'SpecialFX.Blood.Bloodsplatter'
     PreloadMaterial(4)=Texture'SpecialFX.Blood.Bone'
     PreloadMaterial(5)=Texture'SpecialFX.Blood.Muscle'
     PreloadMaterial(7)=Texture'SpecialFX.Fire.Explosion'
     PreloadMaterial(8)=Texture'SpecialFX.Fire.ExplosionFire'
     PreloadMaterial(9)=Texture'SpecialFX.Particles.dust2'
     PreloadMaterial(10)=Texture'SpecialFX.Smoke.smokelight_a'
     PreloadMaterial(11)=Texture'SpecialFX.Smoke.Smoke'
     PreloadMaterial(12)=Texture'SpecialFX.Fire.LargeFlames2'
     DefaultPlayerClassName="XDOTZCharacters.TeenagerHuman"
     HUDType="DOTZGame.DOTZHud"
     PlayerControllerClass=Class'DOTZEngine.DOTZPlayerControllerBase'
     DebugFlags=1
}
