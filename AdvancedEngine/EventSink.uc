// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * EventSink - Just outputs messages when it receives events.  Helpful
 *     for debugging.
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Dec 2003
 */
class EventSink extends AdvancedActor
   placeable;


//===========================================================================
// Editable properties
//===========================================================================


//===========================================================================
// Internal data
//===========================================================================


//===========================================================================
// Example section
//===========================================================================

/**
 * 
 */
function TriggerEx( Actor sender, Pawn instigator, Name handler ) {
    local String msg;
    msg = self @ "received event for handler [" $ handler 
             $ "] from" @ sender @ "instigated by" @ instigator;
    Log( msg );
    Level.GetLocalPlayerController()
        .ClientMessage( msg, class'AdvancedHud'.default.DEBUG_MSG );
}

//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     bHasHandlers=True
}
