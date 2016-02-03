// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class Vehicle extends Pawn
    native
    abstract;
    
var() byte Team;
var bool bDefensive; // should be used by defenders

// generic controls (set by controller, used by concrete derived classes)
var (KVehicle) float    Steering; // between -1 and 1
var (KVehicle) float    Throttle; // between -1 and 1


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if ( !bDeleteMe )
		Level.Game.RegisterVehicle(self);
}

// AI code
function bool Occupied()
{
	return ( Controller != None );
}

function Actor GetBestEntry(Pawn P)
{
	return self;
}

cpptext
{
	virtual UBOOL moveToward(const FVector &Dest, AActor *GoalActor);
	virtual void rotateToward(AActor *Focus, FVector FocalPoint);
	virtual int pointReachable(FVector aPoint, int bKnowVisible=0);
	virtual int actorReachable(AActor *Other, UBOOL bKnowVisible=0, UBOOL bNoAnchorCheck=0);

}


defaultproperties
{
     Team=255
}
