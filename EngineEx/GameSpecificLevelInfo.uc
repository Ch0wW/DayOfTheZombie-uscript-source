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
 * @version $Revision: #4 $
 */
class GameSpecificLevelInfo extends ExtendedLevelInfo;

//===========================================================================
// Level Specific data
//===========================================================================
var() editinline MultiObjective LevelObjectives;
//var() int ChapterNumber;
//var() int PageNumber;
//var() int RevealledTo;
var() string LevelName;

var() array<string> StartingWeapons;
var() string PlayerClass;
var() array<mesh> PreloadMesh;
var() array<MeshAnimation> PreloadAnimation;
var() array<Material> PreloadMaterial;

var() editinline array<SubtitleSequence> TheSubtitles;


//===========================================================================
// defaultProperties
//===========================================================================

defaultproperties
{
     LevelName="Unknown"
}
