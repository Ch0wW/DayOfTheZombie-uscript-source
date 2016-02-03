// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DGActionTriggerGroup - Performs the the specified group's trigger action.
 *
 * @Author  Neil Gower (neilg@digitalextremes.com)
 * @Version $Rev: 5335 $
 * @Date    July 2003
 */
class DGActionTriggerGroup extends DestructGroupAction;


//===========================================================================
// Editable properties
//===========================================================================

var(DestructGroupAction) name LinkedGroup;


//===========================================================================
// DestructGroupAction hooks
//===========================================================================\

/**
 * Performs the the specified group's next action.
 */
function doAction( DestructEffectsGroup g ) {
   local DestructEffectsGroup dg;
   local String out;

   if ( g.GroupRadius > 0 ) {
      ForEach g.RadiusActors(class'DestructEffectsGroup', dg, g.GroupRadius) {
         if ( dg.DGroupName == LinkedGroup ) {
            dg.OnTrigger.doAction( dg );
            return;
         }
      }
   }
   else {
      ForEach g.AllActors( class'DestructEffectsGroup', dg ) {
         if ( dg.DGroupName == LinkedGroup ) {
            dg.OnTrigger.doAction( dg );
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
