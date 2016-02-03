// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DestructEffectsGroup - manages a group of related DestructEffectsActors,
 * so that they can be triggered together.
 *
 * IMPORTANT NOTES:
 *
 *    - The GroupRadius feature was added to allow cut-and-paste of DGroups.
 *      This only works properly if done BEFORE adding DestructGroupActions,
 *      because only the references get duplicated by UnrealEd.
 *
 * TODO:
 *    - manage performance of group
 *    - add event binding support
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Rev: 5335 $
 * @date    June 2003
 */
class DestructEffectsGroup extends Actor
   placeable;

#exec texture Import File=Textures\AlienAttack.tga Name=DEGrpIcon Mips=Off MASKED=1


//===========================================================================
// Editable properties
//===========================================================================

// the name to use for referring to this group
var() Name DGroupName;
// if > 0, this group will ignore registerDActor calls, and find the
// DActors itself by looking for all DActors with the same DGroupName
// within the GroupRadius (in Unreal Units)
var() float GroupRadius;
// The action to execute when an actor in this group goes into it's
// destruction sequence.
var() editinline DestructGroupAction OnActorDestruct;
// The action to execute when an actor in this group disappears.
var() editinline DestructGroupAction OnActorDisappear;
// The action to execute when the group is initialized
//var() editinline DestructGroupAction OnStartup;
// The action to perform when this group object is triggered (by a
// regular Unreal trigger).
var() editinline DestructGroupAction OnTrigger;
// produce debugging info in the game log
var() bool bDebugLogging;


//===========================================================================
// Internal data
//===========================================================================
struct DActorInfo {
   var DestructEffectsActor theActor;
};

var private array<DActorInfo> myDActors;
var private int numIntactDActors;
var private int totalDActors;
var float totalHealth;
var float currentHealth;


//===========================================================================
// Interface for DestructGroupActions
//===========================================================================

/**
 * @return the number of actors in this group that are currently intact.
 */
function int GetNumIntactDActors() {
    return numIntactDActors;
}

/**
 * @return the total number of actors in this group.
 */
function int GetNumDActors() {
    return totalDActors;
}

/**
 * @return the actor at the specified index in this group.
 */
function DestructEffectsActor GetDActor( int index ) {
    //TODO: replace with an iterator
    return myDActors[index].theActor;
}


//===========================================================================
// Interface for DestructEffectsActors
//===========================================================================

/**
 * Call to add actor to this group
 */
function RegisterDActor( DestructEffectsActor d ) {
    if ( GroupRadius > 0 ) return;
    addDActor( d );
}

/**
 * Call when actor goes to destructed state
 */
function NotifyDestruct( DestructEffectsActor d ) {
    DebugLog( "DActor " $ d $ " notified of destruction, doing "
              $ OnActorDestruct );
    --numIntactDActors;
    if ( OnActorDestruct != None ) OnActorDestruct.doAction( self );
}

/**
 * Call when actor disappears
 */
function NotifyDisappear( DestructEffectsActor d ) {
    DebugLog( "DActor " $ d $ " notified of disappear" );
    if ( OnActorDisappear != None ) OnActorDisappear.doAction( self );
}

function NotifyTookDamage( DestructEffectsActor d, float damage ) {
    DebugLog( "DActor" @ d @ "notifyed of" @ damage @ "damage" );
    currentHealth -= damage;
}


//===========================================================================
// Other exposed methods...
//===========================================================================

/**
 * When triggered...
 */
function Trigger( Actor other, Pawn Instigator ) {
    DebugLog( "triggered" );
    if ( OnTrigger != None ) OnTrigger.doAction( self );
}

/**
 * Restore group to the same state as at the beginning of the game.
 */
function ResetGroup () {
    local int i;

    currentHealth = 0;
    numIntactDActors = 0;
    for (i = 0; i < myDActors.length; ++i) {
        if (myDActors[i].theActor.IsInState ('Intact')) {
            ++numIntactDActors;
            currentHealth += myDActors[i].theActor.getCurrentHealth ();
        }
    }
    totalHealth = currentHealth;
    // reset actions
    if (OnActorDestruct != None) { OnActorDestruct.Reset (); }
    if (OnActorDisappear != None) { OnActorDisappear.Reset (); }
    if (OnTrigger != None) { OnTrigger.Reset (); }

    DebugLog( "reset group, total DActors" @ numIntactDActors
              @ "group health" @ currentHealth $ "/" $ totalHealth );

}


//===========================================================================
// Internal methods
//===========================================================================

/**
 * Add a DEA to the myDActors array.
 */
function AddDActor( DestructEffectsActor d ) {
    local DActorInfo dInfo;
    dInfo.theActor = d;
    // could check to prevent duplicates here...
    myDActors[totalDActors++] = dInfo;
    totalHealth   += d.getCurrentHealth();
    currentHealth += d.getCurrentHealth();
    if ( d.IsInState('Intact') ) numIntactDActors++;
    DebugLog( "added" @ d @ "to group," @ numIntactDActors $ "/"
              $ totalDActors $ "DActors intact, group health"
              @ currentHealth $ "/" $ totalHealth );
}

/**
 * Find the DEA's that should be in this group.
 */
function GetDActors() {
    local DestructEffectsActor d;
    super.BeginPlay();
    if ( GroupRadius <= 0 ) {
        return;
    }
    ForEach RadiusActors( class'DestructEffectsActor', d, GroupRadius ) {
        if ( d.DGroupName == DGroupName ) {
            d.DGroup = self;
            addDActor( d );
        }
    }
}

/**
 * Handy debugging helper
 */
function DebugLog( coerce String s, optional name tag ) {
    if ( bDebugLogging ) Log( self @ s, 'DT' );
}


//===========================================================================
// Init - Need to wait for DEAs to get into their initial states.
//===========================================================================
auto state Init {
BEGIN:
    Sleep( 1.0 + (FRand() * 2.0) ); // staggered init
    GetDActors();
    ResetGroup();
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     bHidden=True
     Texture=Texture'AdvancedEngine.DEGrpIcon'
     DrawScale=3.000000
}
