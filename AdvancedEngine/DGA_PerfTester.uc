// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DGA_PerfTester - an actor that runs some benchmarking tests on
 * destruct group actions.
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    June 2003
 */
class DGA_PerfTester extends Actor
   placeable;

var Array<DestructEffectsActor> someDActors;
var Array<DestructGroupAction> someActions;
var DestructEffectsGroup myGroup;

var() int numDActors;
var() int numActions;

function PreBeginPlay() {
   local int i;
   myGroup = Spawn( class'DestructEffectsGroup' );
   for ( i = 0; i < numDActors; ++i ) {
      someDActors[i] = Spawn( class'DestructEffectsActor',,, 
                              Location + vect( 0, 1, 0 ) * 72, );
      if ( someDActors[i] == None ) Log( "spawn DActor failed" );
      myGroup.registerDActor( someDActors[i] );
   }
   for ( i = 0; i < numActions; ++i ) {
      someActions[i] = new class'DGActionDestructAll';
      if ( someActions[i] == None ) Log( "create action failed" );
   }

}

//
function Trigger( Actor Other, Pawn EventInstigator ) {
   local float startTime, endTime;
   local int i;
   startTime = Level.TimeSeconds;
   for ( i = 0; i < numActions; ++i ) {
      someActions[i].doAction( myGroup );
   }
   endTime = Level.TimeSeconds;
   Log( "test completed in " $ (endTime - startTime) $ " seconds" );
}

defaultproperties
{
     numDActors=20
     numActions=10
}
