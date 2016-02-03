// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DestructEffectsActor - Useful for placing static meshes in a map that do
 * interesting things when they run out of health (get "destructed").
 *
 * This class gives you lots of control over what happens to an actor
 * AFTER it runs out of health.  A DestructEffectsActor (DEA) progresses
 * through several states in it's lifetime:
 *
 *    1. Intact       - Initial state, the actor is still intact.
 *    2. Destructing  - Actor has taken enough damage to destroy it.  Usually
 *                      accompanied by lots of effects.
 *    3. Disappearing - Actor is in the process of gracefully removing itself
 *                      from the game, so that you don't have effects running
 *                      indefinitely.
 *
 * Beyond the basic features, this class supports:
 *
 *    - Grouping of DEAs.  Behaviour is controlled with DGActions.  This is
 *      useful for handling situation like "if any two struts are destroyed,
 *      the entire bridge collapses".
 *
 *    - Splash damage.  Sensible for explosive objects.  Can control the chain
 *      reaction behaviour with other DEAs.
 *
 *    - Spawning of pickups.  Can spawn pickups when destroyed.  This feature is
 *      currently commented out.
 *
 * Some example applications:
 *
 *    - Shattered glass: create a mesh for the pane of glass and add as a
 *      DestructEffectsActor.  Set the DestructEmitter to something that looks
 *      like shards of glass, set DisappearDelay to 0 so that the pane
 *      disappears immediately.
 *
 *    - Building chunks: create a mesh for the building chunk and place it in
 *      your building as a DestructEffectsActor.  Set InitialHealth and
 *      MinDamageThreshold to values that make your chunk as sturdy as desired.
 *      Set DestructEmitter to something appropriate for when the chunk first
 *      breaks off the building, like a cloud of concrete bits.  Leave
 *      PostDestructPhysics as PHYS_Karma, and the chunk will fall off the
 *      building when destroyed.
 *
 * IMPORTANT NOTES:
 *
 *    - Some shaders will not play nice with the fade code.  Workaround is set
 *      DisappearDelay to 0, which uses bHidden instead of the fade.
 *
 *    - If you change this class to be derived from StaticMeshActor, rather than
 *      KActor, you'll see considerable performance gains.  However, the DEA
 *      will not support InitialPhysics==PHYS_Karma.
 *
 * TODO:
 *
 *    - Replace mesh with karma bits or another mesh on destruction.  Currently
 *      can use a MeshEmitter for this kind of effect.
 *    - Support for objects with multiple materials.
 *    - Consider porting the DGAction system to the event-binding system.  Might
 *      be simpler for LDs to set up.
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Rev: 5335 $
 * @date    May 2003
 */
class DestructEffectsActor extends KActor//StaticMeshActor
    placeable;

#exec NEW StaticMesh File="Models\crate.ASE" Name="DefaultMesh"


//==============================================================================
// Editable properties
//==============================================================================

// "health" the actor has when spawned
var(PreDestruction) int InitialHealth;
// Smallest amount of damage that will affect this actor
var(PreDestruction) int MinDmgThreshold;
// Physics mode when created
var(PreDestruction) EPhysics InitialPhysics;
// An emitter attached to the actor when it is first created.
var(PreDestruction) class<Emitter> PreDestructEmitter;
var(PreDestruction) vector         PreDestructEmitterOffset;
// Multiplier applied to damage caused by vehicles ramming this actor
var(PreDestruction) float RammingDamageFactor;
// DestructEffectsGroup this actor should participate in (if any)
var(PreDestruction) Name DGroupName;
// Output handy, but performance degrading log info.
var(PreDestruction) bool bDebugLogging;

// Spawned when destructed
var(PostDestruction) class<Emitter> DestructEmitter;
var(PostDestruction) vector         DestructEmitterOffset;
//
var(PostDestruction) bool bIgnoreHitMomentum;
// Physics mode after destructed
var(PostDestruction) EPhysics PostDestructPhysics;
// Alternative (damaged) mesh to use once destructed
//var(PostDestruction) StaticMesh DestructMesh;
var StaticMesh DestructMesh;
// Damage the actor can take before disappearing (-1 for ignore damage)
var(PostDestruction) int PostDestructHealth;
// damage caused to nearby actors when destructed
var(PostDestruction) float SplashDamage;
// radius of splash damage
var(PostDestruction) float SplashRadius;
// how long to wait after destruction before inflicting splash damage
var(PostDestruction) float SplashDelay;
// force to apply to actors that get splashed
var(PostDestruction) float Momentum;
// should this actor take splash damage from other destruct effects actors
var(PostDestruction) bool bChainReaction;

// Attached to actor upon destruction
var(PostDestruction) class<Emitter> TrailEmitter;
var(PostDestruction) vector         TrailEmitterOffset;
// Seconds before the actor disappears (-1 for no time-induced disappearing)
var(PostDestruction) float DisappearDelay;
// Spawned when actor disappears
var(PostDestruction) class<Emitter> DisappearEmitter;
var(PostDestruction) vector         DisappearEmitterOffset;
// When disappearing, seconds to fade from solid to invisible (0 for instant)
var(PostDestruction) float DisappearFadeTime;
// Number of steps the fade effect is divided into (more = smoother fade)
var(PostDestruction) int DisappearFadeSteps;
// Should the actor disappear when it hits the ground?
var(PostDestruction) bool DisappearOnGround;

// cause this actor to self-destruct
var (Events) const editconst Name hDestruct;
// reset this actor to intact state
var (Events) const editconst Name hReset;
// triggered when this actor starts it's destruction sequence
var (Events) const Name OnDestruct;


//==============================================================================
// Internal data
//==============================================================================
var int      health;
var vector   dImpulse;
var vector   dHitLocation;
var Emitter  dTrailEmitter, dPreDestructEmitter;
var int      currentStep;
var bool     bDestructInitComplete;
var Actor    myPickup;
var Pawn     destroyer;
var bool     bModifiersCreated;
var array<Modifier> myModifiers;
var DestructEffectsGroup DGroup;
var DynamicDestructEffectsActor dynamicDEA;
var() float ImpactInterval;
var transient float LastImpactTime;
var bool     bAlwaysHidden;

var const int   GROUND_CHECK_LENGTH;
var const float DESTROY_DELAY;
var const float DELAY_RANGE;


//==============================================================================
// Public interface
//==============================================================================

/**
 * Sets this actor's group reference.  Normally, does not override
 * previously set values, unless the force flag is used.
 */
function SetDestructGroup( DestructEffectsGroup dg, optional bool force ) {
    if ( force || DGroup == None ) DGroup = dg;
}

/**
 * Data accessor.
 */
function int GetCurrentHealth() {
    if ( dynamicDEA != None ) {
        return dynamicDEA.GetCurrentHealth();
    }
    else {
        return health;
    }
}


//==============================================================================
// Implementation
//==============================================================================

/**
 * Init..
 */
function BeginPlay() {
    Super.BeginPlay();
    bAlwaysHidden = bHidden;
    RegisterMe(); // only do this once per game
}

/**
 * Stacks ColorModifiers on top of the static mesh's original
 * materials in the Actor's Skins[] array.  The skins materials
 * will override the static mesh's materials, allowing us to
 * manipulate the material through the modifier.
 *
 * CALL THIS METHOD BEFORE YOU START MAKING CALLS TO fadeMe().
 *
 * Based on http://udn.epicgames.com/bin/view/Technical/MaterialTricks
 */
function InitFade() {
    local int i;
    local ColorModifier cm;
    local FinalBlend fb;

    if ( bModifiersCreated ) return;

    CopyMaterialsToSkins();
    for ( i = 0; i < Skins.Length; ++i ) {
        if ( Skins[i] == none ) break;
        // set up colour modifier
        cm = new(Level) class'ColorModifier';
        cm.Color.A = 255;
        cm.Color.R = 128;
        cm.Color.G = 128;
        cm.Color.B = 128;
        cm.RenderTwoSided = false;
        cm.AlphaBlend     = true;
        cm.Material       = Skins[i];
        // set up final blend
        fb = new(Level) class'FinalBlend';
        fb.Material = cm;
        Skins[i]    = fb;
        // store for manipulation later...
        MyModifiers[i] = fb;
    }
    bModifiersCreated = True;
}

/**
 * Changes the alpha value on the materials on this actor's static
 * mesh by deltaA.
 *
 * YOU MUST CALL initFade() ONCE BEFORE YOU START CALLING THIS METHOD.
 */
function FadeMe( int deltaA ) {
    local int i, newAlpha;
    local ColorModifier cm;
    local FinalBlend fb;

    if ( !bModifiersCreated ) {
        Warn( self $ ".fadeMe() called before initFade()" );
    }
    for( i = 0; i < myModifiers.Length; ++i ) {
        fb = FinalBlend( myModifiers[i] );
        cm = ColorModifier( fb.Material );
        newAlpha = cm.Color.A + deltaA;
        if ( deltaA > 0 ) {
            cm.Color.A = min( 255, newAlpha );
        }
        else {
            cm.Color.A = max( 0, newAlpha );
        }
        if ( cm.Color.A < 128 ) fb.ZWrite = false;
    }
}

/**
 * A helper-method for handling damage caused by collisions.
 */
function InflictImpactDamage( vector impactVel, vector impactPos,
                              Actor source ) {
    local int damage;
    damage = VSize( impactVel * 1 );
    DebugLog( "DestructEffectsActor.inflictImpactDamage() doing "
                $ damage $ " damage times multiplier "
                $ RammingDamageFactor );
    TakeDamage( damage * RammingDamageFactor, Pawn(source),
                impactPos, impactVel, class'RammingDmg' );
}

/**
 * Register this DActor with the appropriate DGroup.  If there are
 * any matching DGroups using the GroupRadius approach, this method
 * defers to the DGroups to do the registration, and does nothing.
 */
function RegisterMe() {
    local bool bUsingRadius;
    local DestructEffectsGroup dg;

    if ( DGroupName == '' ) return;

    bUsingRadius = false;
    ForEach AllActors( class'DestructEffectsGroup', dg ) {
        if ( dg.DGroupName == DGroupName ) {
            SetDestructGroup( dg );
            if ( dg.GroupRadius > 0 ) bUsingRadius = true;
        }
    }
    // if any groups with this label are using the radius to find
    // DActors, ignore the results of our search.
    if ( bUsingRadius ) {
        DebugLog( "not registering with group because GroupRadius in use for"
                    @ DGroupName );
        DGroup = None;
    }
    if ( DGroup != None ) {
        DebugLog( "registering with group:" @ DGroup );
        DGroup.registerDActor( self );
    }
}

/**
 * A handy little diagnostics helper
 */
function DebugLog( coerce String s, optional name tag ) {
    if ( bDebugLogging ) Log( self @ s, 'DEA' );
}

/**
 * Performs state-independent damage functionality.
 */
function DoStandardDamage( int damage, Vector hitLocation, Vector momentum,
                           class<DamageType> damageType ) {
    local vector ApplyImpulse;
    if ( damage < MinDmgThreshold ) {
        damage = 0;
    }
    if ( DGroup != None && IsInState( 'Intact' ) ) {
        DGroup.notifyTookDamage( self, min(damage,health) );
    }
    health -= damage;
    // If this actor is doing Karma physics, the hit will apply a force...
    if ( Physics == PHYS_KARMA ) {
        ApplyImpulse
            = Normal( momentum ) * damageType.default.KDamageImpulse;
        KAddImpulse( ApplyImpulse, hitLocation );
    }
    DebugLog( "took" @ damage @ "damage in state" @ GetStateName()
              @ "health remaining" @ Health );
}

/**
 * Pass my settings on to a DynamicDestructEffectsActor (DynamicDEA)
 */
function initDynamicDEA() {
    local DynamicDestructEffectsActor d;
    dynamicDEA = Spawn( class'DynamicDestructEffectsActor' );
    DebugLog( "Destructing, created" @ dynamicDEA );
    d = dynamicDEA;

    // pre-destruct settings, which probably actually aren't much use
    // to the dynamic actor (but supplied for completeness)
    d.InitialHealth            = InitialHealth;
    d.MinDmgThreshold          = MinDmgThreshold;
    d.InitialPhysics           = InitialPhysics;
    d.PreDestructEmitter       = PreDestructEmitter;
    d.PreDestructEmitterOffset = PreDestructEmitterOffset;
    d.RammingDamageFactor      = RammingDamageFactor;
    d.DGroupName               = '';//None;
    d.bDebugLogging            = bDebugLogging;
    d.bHidden                  = bAlwaysHidden;
    // emitters
    d.DestructEmitter          = DestructEmitter;
    d.DestructEmitterOffset    = DestructEmitterOffset;
    // destruction settings
    d.bIgnoreHitMomentum       = bIgnoreHitMomentum;
    d.PostDestructPhysics      = PostDestructPhysics;
    d.DestructMesh             = DestructMesh;
    d.PostDestructHealth       = PostDestructHealth;
    d.SplashDamage             = SplashDamage;
    d.SplashRadius             = SplashRadius;
    d.SplashDelay              = SplashDelay;
    d.Momentum                 = Momentum;
    d.bChainReaction           = bChainReaction;
    // info about the destruct instant
    d.dImpulse     = dImpulse;
    d.dHitLocation = dHitLocation;
    d.destroyer    = destroyer;
    // disappear settings
    d.TrailEmitter             = TrailEmitter;
    d.TrailEmitterOffset       = TrailEmitterOffset;
    d.DisappearDelay           = DisappearDelay;
    d.DisappearEmitter         = DisappearEmitter;
    d.DisappearEmitterOffset   = DisappearEmitterOffset;
    d.DisappearFadeTime        = DisappearFadeTime;
    d.DisappearFadeSteps       = DisappearFadeSteps;
    d.DisappearOnGround        = DisappearOnGround;
    //NOTE: hacked out to remove pickup feature
    //d.Pickups                  = Pickups;
    // some gory stuff to get the mesh/physics right
    d.SetStaticMesh( StaticMesh );
    d.KParams = new(Level) class'KarmaParams';
    CopyMyKParams( KarmaParams(d.KParams) );
    d.SetPhysics( PostDestructPhysics );
    // and finally, some dynamic actor specific config
    d.parentDEA = self;
}

/**
 * Do a memberwise copy of this actor's KParams into k.
 */
function CopyMyKParams( KarmaParams k ) {
    local KarmaParams myKParams;
    DebugLog( "my kparams class is" @ KParams.class @ "other is" @ k.class );
    myKParams = KarmaParams( KParams );
    if ( k == None || myKParams == None ) {
      return;
    }
    // member-wise copy...
    k.KMass           = myKParams.KMass;
    k.KLinearDamping  = myKParams.KLinearDamping;
    k.KAngularDamping = myKParams.KAngularDamping;
    k.KBuoyancy       = myKParams.KBuoyancy;
    k.KStartEnabled   = myKParams.KStartEnabled;
    k.KStartLinVel    = myKParams.KStartLinVel;
    k.KStartAngVel    = myKParams.KStartAngVel;
    k.bHighDetailOnly = myKParams.bHighDetailOnly;
    k.bClientOnly     = myKParams.bClientOnly;
    k.bKStayUpright   = myKParams.bKStayUpright;
    k.bKAllowRotate   = myKParams.bKAllowRotate;
    k.bKNonSphericalInertia  = myKParams.bKNonSphericalInertia;
    k.KActorGravScale        = myKParams.KActorGravScale;
    k.KVelDropBelowThreshold = myKParams.KVelDropBelowThreshold;
    k.bDestroyOnSimError     = myKParams.bDestroyOnSimError;
    k.StayUprightStiffness   = myKParams.StayUprightStiffness;
    k.StayUprightDamping     = myKParams.StayUprightDamping;
    k.SafeTimeMode           = myKParams.SafeTimeMode;
    //var()  array<KRepulsor>    Repulsors;
}

/**
 * Effectively removes this actor from the game, by making it
 * invisible and untouchable.
 *
 * N.B. THIS METHOD CANNOT BE CALLED FROM KImpact(), as it will
 *      interfere with the physics simulation.
 */
function HideMe() {
    // hide the static actor...
    DebugLog( "is PHYS_Karma?" @ (Physics == PHYS_Karma) );
    KDisableCollision( destroyer );
    SetCollision( false, false, false );
    KSetBlockKarma( false );
    bHidden= true;
    FilterStateDirty();
    if ( DGroup != None ) DGroup.notifyDestruct( self );
    if ( dPreDestructEmitter != None ) dPreDestructEmitter.destroy();
    dPreDestructEmitter = None;
}

/**
 * Undoes HideMe(), as if this actor had just begun the game.
 */
function UnHideMe() {
    health = InitialHealth;
    if ( destroyer != None ) KEnableCollision( destroyer );
    // check if I've been destroyed before, and cleanup
    if ( dynamicDEA != None ) {
        dynamicDEA.destroy();
        dynamicDEA = None;
    }
    if ( !bAlwaysHidden ) bHidden = false;
    FilterStateDirty();
    SetPhysics( PHYS_None );
    SetCollision( true, true, true );
    KSetBlockKarma( true );
    if ( PreDestructEmitter != None ) {
        dPreDestructEmitter
            = Spawn( PreDestructEmitter, self,,
                     Location + PreDestructEmitterOffset );
        SetBase( dPreDestructEmitter );
        dPreDestructEmitter.bhardAttach = true;
    }
    else dPreDestructEmitter = None;
}

/**
 * Handle event bindings...
 */
function TriggerEx( Actor other, Pawn instigator, Name handler ) {
    switch ( handler ) {
    case hDestruct:
        if ( GetStateName() != 'Destructing' ) {
            GotoState( 'Destructing' );
            destroyer = instigator;
        }
        break;
    case hReset:
        GotoState( 'Intact' );
        destroyer = None;
        break;
    default:
        super.TriggerEx( other, instigator, handler );
    }
}


//==============================================================================
// Intact - actor still has health left.
//==============================================================================
auto state Intact {

    ignores Tick;

    /**
     * engine callback...
     */
    function TakeDamage( int damage, Pawn instigatedBy, Vector hitLocation,
                         vector momentum, class<DamageType> damageType ) {
        if ( !bChainReaction
                && damageType == class'DestructEffectsSplashDmg' ) {
            // ignore splash damage from other destruct effects actors.
            return;
        }
        DoStandardDamage( damage, hitLocation, momentum, damageType );
        if ( Health < 0 ) {
            destroyer = instigatedBy;
            // carry over hit momentum into next state, in case Physics
            // switches to PHYS_Karma.
            if ( Physics != PHYS_Karma ) {
                dImpulse = Normal(momentum) * damageType.default.KDamageImpulse;
                dHitLocation = hitLocation;
            }
            GotoState( 'Destructing' );
        }
   }

    /**
     * Detects contact with things in the world, subject to
     * ImpactThreshold in KParams.  This gets called back a lot by the
     * engine, hence the time check at beginning.
     */
    event KImpact( actor other, vector impactPos, vector impactVel,
                   vector impactNorm ) {
        // only react to KImpact once every ImpactInterval
        if( Level.TimeSeconds < LastImpactTime + ImpactInterval ) {
            return;
        }
        LastImpactTime = Level.TimeSeconds;
        DebugLog( "KImpacted while intact by" @ other );
        inflictImpactDamage( impactVel, impactPos, other );
    }

    /**
     * Beware - because this static form of DestructEffectsActor is
     * bStatic, it doesn't get ticked, so state code doesn't work.
     * However, Begin/EndState() still happen.
     */
    function BeginState() {
        UnHideMe();
    }

BEGIN:
    //NOTE: NO STATE CODE for bStatic!

} // end state Intact


//==============================================================================
// Destructing - actor has just run out of health!  In this state, the static
//   actor is out of the picture, and the dynamic one is what the player
//   interacts with.
//==============================================================================
state Destructing {

    ignores Tick;

    /**
     * Any damage must be intended for the dynamic actor now.
     */
    function TakeDamage( int damage, Pawn instigatedBy,
                         Vector hitLocation, Vector momentum,
                         class<DamageType> damageType ) {
        if ( dynamicDEA != None ) {
            dynamicDEA.TakeDamage( damage, instigatedBy, hitLocation,
                                   momentum, damageType );
        }
    }

    /**
     * Beware - because this static form of DestructEffectsActor is
     * bStatic, it doesn't get ticked, so state code doesn't work.
     * However, Begin/EndState() still happen.
     */
    function BeginState() {
        // the dynamic DEA will handle hiding me in the next tick...
        if ( OnDestruct != '' ) TriggerEvent( OnDestruct, self, destroyer );
    }

BEGIN:
    //NOTE: NO STATE CODE executes if bStatic==true!
    hideMe();
    // replace me with a dynamic actor to kick around...
    initDynamicDEA();

} // end of state Destructing


//==============================================================================
// Default Properties
//==============================================================================

defaultproperties
{
     InitialHealth=200
     RammingDamageFactor=0.050000
     PostDestructPhysics=PHYS_Karma
     PostDestructHealth=100
     SplashRadius=3000.000000
     Momentum=50000.000000
     bChainReaction=True
     DisappearDelay=-1.000000
     DisappearFadeTime=1.000000
     DisappearFadeSteps=32
     hDestruct="DESTRUCT"
     hReset="Reset"
     ImpactInterval=3.000000
     GROUND_CHECK_LENGTH=16
     DESTROY_DELAY=15.000000
     DELAY_RANGE=3.000000
     Physics=PHYS_None
     StaticMesh=StaticMesh'AdvancedEngine.DefaultMesh'
     bHasHandlers=True
     bPathColliding=True
}
