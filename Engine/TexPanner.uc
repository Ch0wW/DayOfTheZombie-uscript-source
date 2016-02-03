// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class TexPanner extends TexModifier
	editinlinenew
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var() rotator PanDirection;
var() float PanRate;
var Matrix M;

cpptext
{
	// UTexModifier interface
	virtual FMatrix* GetMatrix(FLOAT TimeSeconds);

}


defaultproperties
{
     PanRate=0.100000
}
