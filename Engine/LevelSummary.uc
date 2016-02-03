// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// LevelSummary contains the summary properties from the LevelInfo actor.
// Designed for fast loading.
//=============================================================================
class LevelSummary extends Object
	native;

//-----------------------------------------------------------------------------
// Properties.

// From LevelInfo.
var() localized string Title;
var()           string Author;
var() int	IdealPlayerCount;
var() localized string LevelEnterText;

defaultproperties
{
}
