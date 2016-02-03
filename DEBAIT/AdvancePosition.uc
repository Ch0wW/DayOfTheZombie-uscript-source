// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * AdvancePosition - positions designated in an AdvanceStage as key
 * points that bots should try to reach.
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    June 2003
 */
class AdvancePosition extends StagePathNode
   placeable;

#exec Texture Import File=Textures\AdvanceBall.tga Name=AdvancePositionIcon Mips=Off MASKED=1

// Bots will try to advance to AdvancePositions in increasing order.
var() int SequenceNumber;

defaultproperties
{
     Texture=Texture'DEBAIT.AdvancePositionIcon'
     DrawScale=3.000000
}
