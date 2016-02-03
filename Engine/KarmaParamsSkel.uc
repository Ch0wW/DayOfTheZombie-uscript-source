// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// The Karma physics parameter specific to skeletons.
// NB: All parameters are in KARMA scale!
//=============================================================================

class KarmaParamsSkel extends KarmaParams
	editinlinenew
	native;

var() string KSkeleton;				// Karma Asset to use for this skeleton.

var() bool   bKDoConvulsions;
var() range  KConvulseSpacing;		// Time between convulsions.

// When the skeletal physics starts up, we check this line against the skeleton,
// and apply an impulse with magnitude KShotStrength if we hit a bone.
// This has to be deferred  because ragdoll-startup is.
var transient vector KShotStart; 
var transient vector KShotEnd;
var transient float  KShotStrength;
var transient bool	 bKImportantRagdoll; // This indicates this ragdoll will not be recycled during KMakeRagdollAvailable

defaultproperties
{
     KConvulseSpacing=(Min=0.500000,Max=1.500000)
}
