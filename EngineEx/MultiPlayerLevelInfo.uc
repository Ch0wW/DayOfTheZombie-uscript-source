// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * A place for storing mission-specific info.
 *
 * This class is instantiated by levelinfo (for now), and ensures that
 * information specific to your game is in every level. Thus we ensure
 * the system works.
 *
 * Note that you can do nothing in this class, it is simply for storing
 * data. ExtendedLevelInfo inherits from Object which has no
 * functionality. If you have something cool to do like mission count
 * downs'n'stuff then do it somewhere more appropriate!
 *
 * @author  Jesse LaChapelle (Jesse@digitalextremes.com)
 * @date    Nov 2003
 * @version $Revision: #1 $
 */
class MultiPlayerLevelInfo extends ExtendedLevelInfo;

//===========================================================================
// Level Specific data
//===========================================================================
var() int   InitialInPlayLimit;
var() int   MaxInPlayLimit;
var() int   MinInPlayLimit;
var() float  PerPlayerInPlayLimitModifier;

var() array<string> StartingWeapon;

var() array<mesh> PreloadMesh;
var() array<MeshAnimation> PreloadAnimation;
var() array<Material> PreloadMaterial;

//===========================================================================
// defaultProperties
//===========================================================================

defaultproperties
{
     InitialInPlayLimit=4
     MaxInPlayLimit=5
     MinInPlayLimit=3
     PerPlayerInPlayLimitModifier=1.000000
     StartingWeapon(0)="DOTZWeapons.FistWeapon"
}
