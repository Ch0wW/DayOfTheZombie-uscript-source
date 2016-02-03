// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DefensePosition - positions designated in a DefenseStage as points
 * that are good for positioning bots.
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    June 2003
 */
class DefensePosition extends StagePathNode
   placeable;

#exec Texture Import File=Textures\DefBall.tga Name=DefensePositionIcon Mips=Off MASKED=1

defaultproperties
{
     Texture=Texture'DEBAIT.DefensePositionIcon'
     DrawScale=3.000000
}
