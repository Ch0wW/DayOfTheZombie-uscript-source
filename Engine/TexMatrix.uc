// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class TexMatrix extends TexModifier
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var Matrix Matrix;

cpptext
{
	// UTexModifier interface
	virtual FMatrix* GetMatrix(FLOAT TimeSeconds) { return &Matrix; }

}


defaultproperties
{
}
