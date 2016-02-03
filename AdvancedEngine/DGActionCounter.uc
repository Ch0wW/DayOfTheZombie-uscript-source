// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DGActionCounter - waits to execute the next action until after this action
 * has be performed N times.
 *
 * @Author  Neil Gower (neilg@digitalextremes.com)
 * @Version $Rev: 5335 $
 * @Date    July 2003
 */
class DGActionCounter extends DestructGroupAction;


//===========================================================================
// Editable properties
//===========================================================================

// number of count down from
var() int N;


//===========================================================================
// Internal data
//===========================================================================

var private int count;


//===========================================================================
// DestructGroupAction hooks
//===========================================================================

/**
 */
function init() {
    super.init();
    reset();
}

/**
 * Countdown.
 */
function doAction( DestructEffectsGroup g ) {
    DebugLog( "count at" @ count );
    --count;
    if ( count <= 0 ) {
        NextAction.doAction( g );
    }
}

/**
 */
function reset() {
    super.reset();
    count = N;
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     N=1
}
