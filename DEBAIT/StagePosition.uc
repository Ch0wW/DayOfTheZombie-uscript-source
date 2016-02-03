// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * A generic position for use with DEBAIT stages.  Marks locations on
 * the map that are significant to the stage.  Replaces StagePathNode,
 * which replaced AnnotatedPathNode.
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @author  Mike Horgan (mikeh@digitalextremes.com)
 * @date    Dec 2003
 */
class StagePosition extends Info
	placeable;

#exec Texture Import File=Textures\BlueBall.tga Name=StagePositionIcon Mips=Off MASKED=1


//=====================
// Editable properties
//=====================

// a list of StageNames for the stages this node is part of.
var() Name Stage;
// does this node provide some kind of cover?
var() const bool bProvidesCover;
// 
var() const int CoverAngle;


//=====================
// Internal properties
//=====================

// These must be updated externally, and are round-robin updated, so
// might be stale.

// Enemy info vectors...
//
// 8-bit mask to keep track of 8 LOS's, should be able to shoot while
// standing.
var byte StandLOF;
// another 8-bit mask for line of fire while crouching
var byte CrouchLOF; 
// yet another, this time for cover
var byte CoverValid;

// The node is currently assigned to an NPC for LOS or wandering etc.
var bool bIsClaimed;
// This wouldn't be necessary if nodes were guaranteed to be in a
// certain spot above the ground.
var bool    bDoOnGroundCheck;
var float   OnGroundZ;

var float FearCost;
var float extraCost;
var float fDistToCover;
var float fDistToBuddies;
var float fProjDistToBuddies;

var float coverAngleCosine;

//================
// Implementation
//================
function PreBeginPlay() {
    super.PreBeginPlay();
    // convert half the angle (on either side of center) to radians...
    coverAngleCosine = cos( CoverAngle * (pi/360) );
}

defaultproperties
{
     CoverAngle=90
     bDoOnGroundCheck=True
     bStatic=True
     bNoDelete=True
     bDirectional=True
     Texture=Texture'DEBAIT.StagePositionIcon'
     DrawScale=2.000000
}
