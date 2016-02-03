// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DGActionLinkGroup - Performs the next action on a specified group.
 *
 * @Author  Neil Gower (neilg@digitalextremes.com)
 * @Version $Rev: 5335 $
 * @Date    July 2003
 */
class DGActionLinkGroup extends DestructGroupAction;


//===========================================================================
// Editable properties
//===========================================================================

var(DestructGroupAction) Name LinkedGroup;


//===========================================================================
// DestructGroupAction hooks
//===========================================================================

/**
 * Finds the linked group, and performs the next action on it.
 */
function doAction( DestructEffectsGroup g ) {
    local DestructEffectsGroup dg;
    local String out;

    if ( NextAction == None ) {
        DebugLog( "No link action" );
        return;
    }

    if ( g.GroupRadius > 0 ) {
        ForEach g.RadiusActors(class'DestructEffectsGroup', dg, g.GroupRadius) {
            if ( dg.DGroupName == LinkedGroup ) {
                NextAction.doAction( dg );
                return;
            }
        }
    }
    else {
        ForEach g.AllActors( class'DestructEffectsGroup', dg ) {
            if ( dg.DGroupName == LinkedGroup ) {
                NextAction.doAction( dg );
                return;
            }
        }
    }
    // still going?  didn't find the linked group!
    out = "failed to find group with name" @ LinkedGroup;
    if (g.GroupRadius > 0) out = out @ "in radius" @ g.GroupRadius;
    DebugLog( out );
}

defaultproperties
{
}
