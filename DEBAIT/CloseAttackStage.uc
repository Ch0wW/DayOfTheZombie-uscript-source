// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * CloseAttackStage - The stage induces bots to attack at the closest
 *    range possible.
 *
 * @version $Revision: #1 $
 * @author  Mike Horgan (mikeh@digitalextremes.com)
 * @date    Aug 2003
 */
class CloseAttackStage extends Stage
  placeable;

#exec Texture Import File=Textures\DefenseTower.bmp Name=DefenseStageIcon Mips=Off MASKED=1

function Report_EnemySpotted( Pawn enemy, VGSPAIController spotter )
{
	local int i;

	for(i=0; i<StageAgents.length; i++)
	{
		StageAgents[i].controller.StageOrder_None();
	}
	Super.Report_EnemySpotted(enemy, spotter);
}

/**
 * returns a node that provides Line of Sight to target, if it's not
 * too far away from the agent's assigned position.
 **/
function StagePosition Request_ShootingPosition(VGSPAIController c)
{
	return bestShootPositionAccordingToBot(c);
	//return closestPosition( true, c, c.Pawn.Location );

}


function joinStage( VGSPAIController c )
{
	super.joinStage( c );
	c.StageOrder_TakeUpPosition( randomPosition() );
}
  
/**
 *
 */
function Report_InPosition( VGSPAIController c, StagePosition pos )
{
   if(c.Enemy == None)
	   c.StageOrder_None( );

}

////
// Helpers
///
function StagePosition randomPosition()
{
	local int i, numAvail;
	local StagePosition returnPosition;

	for(i=0; i< StagePositions.Length; i++)
   	{
		if( !StagePositions[i].bIsClaimed )
		{	
			numAvail++;
						
			if( FRand() < 1.0f/float(numAvail) ) //  odds are  1/1, 1/2, 1/3, 1/4 ...
			{
				returnPosition = StagePositions[i];
			}
		}
	}
	return returnPosition;
}

//Doesn't do anything, but we can't have tick ignored
auto state Init {
}

defaultproperties
{
}
