// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ConstantMaterial extends RenderedMaterial
	editinlinenew
	abstract
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

cpptext
{
	//
	// UConstantMaterial interface
	//
	virtual FColor GetColor(FLOAT TimeSeconds) { return FColor(0,0,0,0); }

}


defaultproperties
{
}
