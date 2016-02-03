// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DGActionTriggerEvent - causes an event to occur.
 *
 * @Author  Neil Gower (neilg@digitalextremes.com)
 * @Version $Rev: 5335 $
 * @Date    Dec 2003
 */
class DGActionTriggerEvent extends DestructGroupAction;


//===========================================================================
// Editable properties
//===========================================================================

var(DestructGroupAction) Name EventName;


//===========================================================================
// DestructGroupAction hooks
//===========================================================================

/**
 * Triggers the event.
 */
function doAction( DestructEffectsGroup g ) {
   Super.doAction( g );
   g.TriggerEvent( EventName, g, None );
}

defaultproperties
{
}
