// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * PatrolPosition - 
 *
 * @version $Revision: #1 $
 * @author  Mike Horgan (mikeh@digitalextremes.com)
 * @date    Dec 2003
 */
class PatrolPosition extends StagePathNode
    placeable;

#exec Texture Import File=Textures\PatBall.tga Name=PatrolPositionIcon Mips=Off MASKED=1

var() Name	nextPatrolPosition;
var() bool	bStartPosition;

var PatrolPosition  nextPosition;

/**
 */
function PreBeginPlay() 
{
    local PatrolPosition pn;
    ForEach AllActors( class'PatrolPosition', pn )
    {
        if(nextPatrolPosition == pn.Tag)
        {	
            nextPosition = pn;
            break;
        }
    }
}

defaultproperties
{
     Texture=Texture'DEBAIT.PatrolPositionIcon'
     DrawScale=3.000000
}
