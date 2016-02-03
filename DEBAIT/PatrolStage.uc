// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * PatrolStage - 
 *
 * @version $Revision: #1 $
 * @author  Mike Horgan (mikeh@digitalextremes.com)
 * @date    Oct 2003
 */
class PatrolStage extends Stage
	placeable;

#exec Texture Import File=Textures\PatrolTower.tga Name=PatrolStageIcon Mips=Off MASKED=1


//===============
// Internal data
//===============
var Array<PatrolPosition> PatrolPositions;
var Array<PatrolInfo> AgentPatrolPositions;

//=============================
// Controller->Stage interface
//=============================

/**
 * Alert other agents of bogie
 **/
function Report_EnemySpotted( Pawn enemy, VGSPAIController spotter )
{
   local int i;

   Super.Report_EnemySpotted(enemy, spotter);

   DebugLog( "enemy (" @ Enemy @ ") spotted " );
   for(i=0; i<StageAgents.length; i++)
   {
      StageAgents[i].controller.StageOrder_None();
   }
   GotoState('Alerted');
}

/**
 *
 */
function Report_InPosition( VGSPAIController c, StagePosition pos ) {
	local PatrolInfo patInfo;
	
	patInfo = getPatrolInfo( c );
	if ( patInfo.node.nextPosition != None)
	{
		patInfo.node = patInfo.node.nextPosition;
		c.StageOrder_TakeUpPosition(patInfo.node);
	}
}

/**
 * When agents join, assign them a position.
 */
function joinStage( VGSPAIController c )
{
	local int i;
	local PatrolPosition node;

	super.joinStage( c );
	if ( c.Tag != '')
		node = pickAssignedPatrolStart(c);
	else
		node = pickRandomPatrolStart();
	if(node != None)
	{
		i = AgentPatrolPositions.length;
		AgentPatrolPositions.length = i + 1;
		AgentPatrolPositions[i] = new(Level) class'PatrolInfo';
		AgentPatrolPositions[i].patroller = c;	
		AgentPatrolPositions[i].node = node;	
		c.StageOrder_TakeUpPosition( node );
	}
	
}
/**
 * returns a node that provides Line of Sight to target
 **/
function StagePosition Request_ShootingNode(VGSPAIController c)
{
	return bestShootPositionAccordingToBot(c);
	//return closestNode(true, c, c.Enemy.Location);
}

//================
// Implementation
//================

/**
 */
function PostBeginPlay() {
	local int i, numPatrolPositions;
	local PatrolPosition pn;

	super.PostBeginPlay();
	numPatrolPositions = 0;
	for ( i = 0; i < StagePositions.length; ++i )
	{
		pn = PatrolPosition( StagePositions[i] );
		if ( pn != None )
		{
			PatrolPositions[numPatrolPositions++] = pn;
		}
	}
}

function PatrolPosition pickAssignedPatrolStart( VGSPAIController patroller )
{
	local int i;
	
	for ( i = 0; i < PatrolPositions.length; ++i )
	{
		if ( PatrolPositions[i].Tag == patroller.Tag )
		{
			return PatrolPositions[i];
		}
	}
	return None;
}

function PatrolPosition pickRandomPatrolStart()
{
	local int i, num;
	local PatrolPosition returnPosition;

	returnPosition = None;
	for ( i = 0; i < PatrolPositions.length; ++i )
	{
		if ( PatrolPositions[i].bStartPosition )
		{
			num++;
			if( FRand() < 1.0f/float(num) ) //  odds are  1/1, 1/2, 1/3, 1/4 ...
			{
				returnPosition = PatrolPositions[i];
			}
		}
	}
	return returnPosition;
}


/**
 * gets the patrolnode info for a particular defender.
 */
function PatrolInfo getPatrolInfo( VGSPAIController c ) {
   local int i;
   for ( i = 0; i < AgentPatrolPositions.length; ++i ) {
      if ( AgentPatrolPositions[i].patroller == c ) {
         return AgentPatrolPositions[i];
      }
   }
   return None;
}

//Doesn't do anything, but we can't have tick ignored
auto state Init
{
}

//We're currently entertaining enemies, don't patrol
state Alerted extends Engaged
{
	function joinStage( VGSPAIController c )
	{
		super.joinStage( c );
	}

	function Report_EnemySpotted( Pawn enemy, VGSPAIController spotter )
	{
		Super.Report_EnemySpotted( enemy, spotter );
	}

}

defaultproperties
{
     Texture=Texture'DEBAIT.PatrolStageIcon'
     DrawScale=3.000000
}
