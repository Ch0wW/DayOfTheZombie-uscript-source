// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * Attractor -
 *
 * @version $Rev: 2722 $
 * @author  Jesse LaChapelle (jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    June 2004
 */
class Attractor extends AdvancedActor
    placeable;



#exec texture Import File=Textures/Attractor.tga Name=AttractorIcon Mips=Off MASKED=1

//===========================================================================
// Public attributes
//===========================================================================

// Proportion of listener's HearingThreshold [0..1]
var(Attractor) float Loudness;
// How often (in seconds) the noise is heard by pawns.
var(Attractor) float NoisePeriod;
var(Events) name OnActivateEvent;
var(Events) Name OnDeactivateEvent;

// event handlers...
var(Events) editconst const Name hEnable;
var(Events) editconst const Name hDisable;


//===========================================================================
// Internal data
//===========================================================================
var bool bActive;
var Pawn Activator;
const MAKE_NOISE_TIMER = 102848;


/****************************************************************
 * Activate
 ****************************************************************
 */
function Activate( Pawn eventInstigator){
    Activator  = EventInstigator;
    Instigator = EventInstigator;
    bActive    = true;
                // Log( self @ "making noise"  )    ;
    MakeNoise( Loudness );
    SetMultiTimer( MAKE_NOISE_TIMER, NoisePeriod, true );
    triggerEvent( OnActivateEvent, self, eventInstigator );
}

/****************************************************************
 * Deactivate
 ****************************************************************
 */
function Deactivate(){
   bActive = false;
   SetMultiTimer( MAKE_NOISE_TIMER, 0, false );
   triggerEvent( OnDeactivateEvent, self, Instigator );
}

/**
 */
event MultiTimer( int timerID ) {
    switch( timerID ) {

    case MAKE_NOISE_TIMER:
                    // Log( self @ "making noise"  )    ;
        MakeNoise( Loudness );
        break;

    default:
        super.MultiTimer( timerID );
    }
}

/****************************************************************
 * TriggerEx
 ****************************************************************
 */
event TriggerEx( Actor Other, Pawn EventInstigator, Name Handler ) {

   //Enable
   if (Handler == hEnable) {
      Activate( eventInstigator );
   }
   //Diable
   else if (Handler == hDisable){
      Deactivate();
   }
   //pass this unhandled event to your parent
   else {
      Super.TriggerEx(Other,EventInstigator,Handler);
   }
}

/**
 * Make sure everything is cleaned up properly (events triggered)
 */
function Destroyed() {
    Deactivate();
    super.Destroyed();
}

//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     Loudness=1.000000
     NoisePeriod=3.000000
     hEnable="Enable"
     hDisable="Disable"
     bHidden=True
     bHasHandlers=True
     bCollideActors=True
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
     DebugFlags=1
     Texture=Texture'DOTZEngine.AttractorIcon'
}
