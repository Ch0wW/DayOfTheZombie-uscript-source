// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DGActionThresholdDestruct - a DestructGroupAction which triggers the
 * destruction sequences of the remaining intact actors in the group only after
 * the number of intact actors drops below a specified threshold.
 *
 * @Author  Neil Gower (neilg@digitalextremes.com)
 * @Version $Rev: 5335 $
 * @Date    June 2003
 */
class DGActionThresholdDestruct extends DGActionDestructAll;


//===========================================================================
// Editable properties
//===========================================================================

// the smallest number of intact actors that can be in this group
// before the rest will be destroyed.
var() int MinIntactActors;


//===========================================================================
// DestructGroupAction hooks
//===========================================================================

/**
 * Causes all intact actors in the group to start their destruct
 * sequence.
 */
function doAction( DestructEffectsGroup g ) {
    DebugLog( g @ "has" @ g.getNumIntactDActors() $ ", threshold is"
              @ MinIntactActors );
    if ( g.getNumIntactDActors() < MinIntactActors ) {
        super.doAction( g );
    }
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     MinIntactActors=1
}
