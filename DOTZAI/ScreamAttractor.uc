// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ScreamAttractor -
 *
 * @version $Rev: 2549 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    July 2004
 */
class ScreamAttractor extends Attractor;

/**
 * Call to start the scream attractor
 */
function StartScream( Pawn screamer, Name OnScreamEvent ) {
   OnActivateEvent = OnScreamEvent;
   activate( screamer );
}

//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     Loudness=0.700000
}
