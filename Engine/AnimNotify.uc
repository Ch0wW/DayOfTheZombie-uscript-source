// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class AnimNotify extends Object
	native
	abstract
	editinlinenew
	hidecategories(Object)
	collapsecategories;

var transient int Revision;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

cpptext
{
	// AnimNotify interface.
	virtual void Notify( UMeshInstance *Instance, AActor *Owner ) {};
	// UObject interface.
	virtual void PostEditChange();

}


defaultproperties
{
}
