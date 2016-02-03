// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DynamicDestructEffectsActor - this is the actor that's swapped in upon
 * destruction, after the static actor is hidden.  This class should NOT be
 * used by LDs.
 *
 * Splitting the DEA into two actors allows the original to stay in place, so
 * that it can be reset later.  It also opens up the opportunity for optimizing
 * the static DEAs, since they may not need to move at all (so can be static
 * meshes).
 *
 * @version $Rev: 5335 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Sept 2003
 */
class DynamicDestructEffectsActor extends DestructEffectsActor
   notplaceable;


//===========================================================================
// Internal data
//===========================================================================

var DestructEffectsActor parentDEA;
var Emitter myDestructEmitter, myDisappearEmitter;


//===========================================================================
// DEA overrides...
//===========================================================================

/**
 */
function HideMe() {
    // no-op
}

/**
 */
function UnHideMe() {
    // no-op
}

/**
 */
function inflictImpactDamage( vector impactVel, vector impactPos,
                              Actor source ) {
    // no-op, to protect against karma crashing
}

/**
 * Make sure stuff we spawned is properly cleaned up...
 */
function Destroyed() {
    Super.Destroyed();
    if ( myPickup != None ) myPickup.Destroy();
    myPickup = None;
    if ( myDisappearEmitter != None ) myDisappearEmitter.Destroy();
    myDisappearEmitter = None;
    if ( myDestructEmitter != None ) myDestructEmitter.Destroy();
    myDestructEmitter = None;
    if ( dTrailEmitter != None ) dTrailEmitter.Destroy();
    dTrailEmitter = None;
}


//===========================================================================
// Destructing - actor has just run out of health!
//===========================================================================
auto state Destructing {

    /**
     * Handles damage inflicted after the actor has run out of initial
     * health.
     */
    event TakeDamage( int damage, Pawn instigatedBy, Vector hitLocation,
                      Vector momentum, class<DamageType> damageType ) {
        if ( !bDestructInitComplete ) return;
        if ( !bChainReaction
                && damageType == class'DestructEffectsSplashDmg' ) {
            // ignore splash damage from other destruct effects actors.
            return;
        }
        if ( PostDestructHealth == -1 ) damage = 0;
        DoStandardDamage( damage, hitLocation, momentum, damageType );
        DebugLog( "took" @ damage
                  @ "damage while destructing, health remaining" @ Health );
        if ( health < 0 ) GotoState( 'Disappearing' );
    }

    /**
     * Used to make the actor disappear after a set amount of time.
     */
    event Timer() {
        GotoState( 'Disappearing' );
    }

    /**
     * Detects contact with things in the world, subject to
     * ImpactThreshold in KParams.  This gets called back a lot by the
     * engine, hence the time check at beginning.
     */
    event KImpact( actor other, vector impactPos, vector impactVel,
                  vector impactNorm ) {
        local Actor belowMe;
        local vector hitLocn, hitNorm;

        if( Level.TimeSeconds < LastImpactTime + ImpactInterval ) {
            return;
        }
        LastImpactTime = Level.TimeSeconds;
        DebugLog( "KImpacted while destructing, by" @ other );
        // KImpact() sometimes gives us None for other, such as when
        // this actor hits world geometry or terrain...
        if ( DisappearOnGround && other == None ) {
            // check what's below this actor...
            belowMe = Trace( hitLocn, hitNorm,
                             impactPos + vect(0,0,-1) * GROUND_CHECK_LENGTH,
                             impactPos );
            // It's the ground, that's probably what we hit...
            if ( TerrainInfo(belowMe) != None || LevelInfo(belowMe) != None ) {
                GotoState( 'Disappearing' );
            }
            // hmmmm... don't know what we hit.
            else {
                DebugLog( "DestructEffectsActor.KImpact( None, ... ) with "
                          $ " unexpected Actor, " $ belowMe );
            }
        }
        else {
            // hit by a vehicle...
            if ( KVehicle(other) != None || SVehicle(other) != None ) {
                // do some damage
                inflictImpactDamage( impactVel, impactPos, other );
            }
        }
    }

    function BeginState() {
        // make sure Super.BeginState() doesn't happen, else infinite recursion
    }

// Destruct sequence...
BEGIN:
    DebugLog( "destructing" );
    if ( Physics == PHYS_KARMA ) DebugLog( "physics is karma" );
    else DebugLog( "not karma" );
    if ( Physics == PHYS_KARMA && !bIgnoreHitMomentum ) {
        KAddImpulse( dImpulse, dHitLocation );
    }
    health = PostDestructHealth;
    bDestructInitComplete = true;
    if ( DGroup != None ) DGroup.notifyDestruct( self );
    //FIXME behaves weirdly: appears semi-transparent and seems to mess
    //      up karma.
    //if ( DestructMesh != None ) SetStaticMesh( DestructMesh );
    initFade();
    if ( DestructEmitter != None ) {
        myDestructEmitter
            = Spawn( DestructEmitter, self,, Location + DestructEmitterOffset );
    }
    if ( TrailEmitter != None ) {
        dTrailEmitter
            = Spawn( TrailEmitter, self,, Location + DestructEmitterOffset );
        SetBase( dTrailEmitter );
        dTrailEmitter.bhardAttach = true;
    }
    TriggerEvent( Event, self, destroyer );
    if ( splashDamage > 0 ) {
        Sleep( SplashDelay );
        HurtRadius( splashDamage, splashRadius, class'DestructEffectsSplashDmg',
                    momentum, location );
    }
    if ( DisappearDelay != -1 ) {
        // needed because SetTimer(0) means cancel timer.  :-(
        if ( DisappearDelay < 0.1 ) GotoState( 'Disappearing' );
        else SetTimer( DisappearDelay, false );
    }

} // end state Destructing


//===========================================================================
// State: Disappearing - actor is being removed from the game
//===========================================================================
state Disappearing {

BEGIN:
    DebugLog( self $ " is disappearing" );
    if ( DGroup != None ) DGroup.notifyDisappear( self );
    if ( DisappearEmitter != None ) {
        myDisappearEmitter
            = Spawn( DisappearEmitter, self,,
                     Location + DisappearEmitterOffset );
    }
    if ( DisappearFadeTime > 0 ) {
        if ( DisappearFadeSteps < 1 ) DisappearFadeSteps = 1;
        for (currentStep=0; currentStep<DisappearFadeSteps; ++currentStep) {
            fadeMe( -1 * (255 / DisappearFadeSteps) );
            Sleep( DisappearFadeTime / float(DisappearFadeSteps) );
        }
    }
    fadeMe( -255 );
    bHidden = true;
    SetCollision( false, false, false );
    // if you destroy too soon, the emitters are afffected (they slow down).
    Sleep( DESTROY_DELAY + FRand() * DELAY_RANGE );
    Destroy();

} // end state Disappearing


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     bNoDelete=False
     Begin Object Class=KarmaParams Name=KParams0
         KStartEnabled=True
         bHighDetailOnly=False
         KFriction=1.000000
         KImpactThreshold=1.000000
         Name="KParams0"
     End Object
     KParams=KarmaParams'AdvancedEngine.DynamicDestructEffectsActor.KParams0'
}
