// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// AlternatePath.
//=============================================================================
class AlternatePath extends NavigationPoint
	notplaceable;

var() byte Team;
var() float SelectionWeight;
var() bool bReturnOnly;

defaultproperties
{
     SelectionWeight=1.000000
     bObsolete=True
}
