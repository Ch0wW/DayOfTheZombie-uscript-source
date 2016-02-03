// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * OtisAIController -
 *
 * @version $Rev: 4874 $
 * @author  Jesse LaChapelle (jesse@digitalextremes.com)
 * @date    June 2004
 */
class OtisAIController extends DOTZAIController;



var const Material OtisDeadOverlay;
var localized string xboxMsg;
var localized string PCMsg;



//===========================================================================
//
//===========================================================================

/**
 */
function Possess( Pawn p ) {
    super.Possess( p );
    p.GiveWeapon( "DOTZWeapons.OtisRevolverWeapon" );
}

/**
 */
function bool SameTeamAs(Controller C) {
    // not a zombie, on my team.
    return (ZombieAIController(c) == None);
}


//===========================================================================
// Otis-death game logic...
//===========================================================================

/**
 */
function PawnDied(Pawn P) {
    local AdvancedPlayerController apc;

    Super.PawnDied(P);
    apc = AdvancedPlayerController( Level.GetLocalPlayerController() );
    //make sure that the player doesn't die too
    AdvancedPawn(apc.Pawn).bGodMode = true;
    //make the view of the dead otis
    apc.bBehindView = true;
    apc.SetViewTarget(p);
    apc.Unpossess();
    //apc.SpectatingOverlay = OtisDeadOverlay;
    //XBOX
    if (apc.IsA('XDotzPlayerController') == true){
      apc.SpectatingMsg = xboxMsg;
    } else {
      apc.SpectatingMsg = PCMsg;
    }
}


/*function bool FireWeaponAt(Actor A)
{
    //DebugLog( "Trying to fire at" @ A );
    if ( A == None ) A = Enemy;
    Target = A;
    if ( (Pawn.Weapon != None) && Pawn.Weapon.HasAmmo()
             && !Pawn.Weapon.IsFiring() ) {
        NumShotsToGo = iRandRange(MinNumShots,MaxNumShots);
        CalculateMissVectorScale();
        return WeaponFireAgain(Pawn.Weapon.RefireRate(),false);
    }
    else {
        DebugLog( "Unable to fire weapon:" @ Pawn.weapon, DEBUG_FIRING );
        return false;
    }
}
*/

function Perform_NotEngaged_AtRest()
{
    curBehaviour = "Rest";
    //GotoState('NotEngaged_AtRest');
    Perform_Engaged_StandGround();
}

//===========================================================================
// Helpers
//===========================================================================



//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     xboxMsg="Game Over. Press START to continue."
     PCMsg="Game Over. Press fire to continue."
     MinNumShots=1
     MaxNumShots=1
     MinShotPeriod=0.800000
     MaxShotPeriod=2.200000
     MaxAimRange=1000.000000
     MaxSecondsOfLOS=5.000000
}
