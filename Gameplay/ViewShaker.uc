// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// ViewShaker:  Shakes view of any playercontrollers 
// within the ShakeRadius
//=============================================================================
class ViewShaker extends Triggers;

//-----------------------------------------------------------------------------
// Variables.

var() float ShakeRadius;			// radius within which to shake player views
var() float ViewRollTime;			// how long to roll the instigator's view
var() float RollMag;				// how far to roll view
var() float RollRate;				// how fast to roll view
var() float OffsetMagVertical;		// max view offset vertically
var() float OffsetRateVertical;		// how fast to offset view vertically
var() float OffsetMagHorizontal;	// max view offset horizontally
var() float OffsetRateHorizontal;	// how fast to offset view horizontally
var() float OffsetIterations;		// how many iterations to offset view


//-----------------------------------------------------------------------------
// Functions.

function Trigger( actor Other, pawn EventInstigator )
{
	local Controller C;
	local vector OffsetMag, OffsetRate;

	OffsetMag = OffsetMagHorizontal * vect(1,1,0) + OffsetMagVertical * vect(0,0,1);
	OffsetRate = OffsetRateHorizontal * vect(1,1,0) + OffsetRateVertical * vect(0,0,1);
	for ( C=Level.ControllerList; C!=None; C=C.NextController )
		if ( (PlayerController(C) != None) && (VSize(Location - PlayerController(C).ViewTarget.Location) < ShakeRadius) )		
			C.ShakeView(ViewRollTime,RollMag,OffsetMag,RollRate,OffsetRate,OffsetIterations);
}

defaultproperties
{
     ShakeRadius=2000.000000
     OffsetMagVertical=10.000000
     OffsetRateVertical=400.000000
     OffsetRateHorizontal=353.000000
     OffsetIterations=500.000000
     Texture=Texture'Gameplay.S_SpecialEvent'
}
