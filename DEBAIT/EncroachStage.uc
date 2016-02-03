// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * EncroachStage - agents attempt to encroach on predetermined enemy
 *     positions by moving between AdvancePositions.  
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Dec 2003
 */
class EncroachStage extends Stage
   abstract;

#exec Texture Import File=Textures\encroach.tga Name=EncroachStageIcon Mips=Off MASKED=1 

//===========================================================================
// Editable properties
//===========================================================================

// seconds between attempts to creep forward.
var(Stage) int AdvanceFrequency;


//===========================================================================
// Internal data
//===========================================================================

struct EnemyPosition {
    var vector locn;
    var rotator rotn;
};

var private Array<EncroachPosnInfo> EncroachPositions;
var private int nextPosnIdx;
var private const int ENCROACH_TIMER;
var private const int WACKAMOLE_TIMER;
var private int encroachTimer;
var private bool bHiding;

//===========================================================================
// EncroachStage Hooks
//===========================================================================

/**
 * Override in subclasses to use a game-specific mechanism to identify
 * the positions to try to encroach on.
 */
function Array<EnemyPosition> getEnemyPositions() {
    local Array<EnemyPosition> enemyPosns;
    
    return enemyPosns;
}

/**
 * Returns the index of an appropriate first position for a bot to
 * take up.  -1 on error.
 */
function int SelectInitialPosition( VGSPAIController c ) {
    local int closest, i;
    closest = -1;
    for ( i = 0; i < encroachPositions.length; ++i ) {
        if ( encroachPositions[i].agent != None ) continue;
        // take the closest position...
        if ( closest < 0 
               || VSize(encroachPositions[i].pos.location - c.pawn.location)
                    < VSize(encroachPositions[closest].pos.location 
                             - c.pawn.location) ) {
            closest = i;    
        }
    }
    return closest;
}

/**
 * Choose an enemy for this bot.
 */
function Pawn SelectInitialEnemy() {
    local int i;

    for ( i = 0; i < MAXENEMY; ++i ) {
        if ( enemies[i] != None && enemies[i].isHumanControlled() ) {
            return enemies[i];
        }
    }
    return None;
}

//===========================================================================
// Stage hooks
//===========================================================================

/**
 *
 */
function Report_InPosition( VGSPAIController c, StagePosition pos ) {
    local EncroachPosnInfo dest;
    dest = getCoverPointInfo( c );
    if ( dest != None ) {
        Log( "In position:" @ c );
        dest.inPosition = true;
    }
    c.StageOrder_TakeCover( pos );
}

/**
 * When agents join, assign them a position.struct 
 */
function joinStage( VGSPAIController c ) {
    local int posnIndex;

    super.joinStage( c );
    if ( c == None ) return;
    posnIndex = SelectInitialPosition( c );
    if ( posnIndex >= 0 && posnIndex < encroachPositions.length  ) {
        encroachPositions[posnIndex].agent      = c;
        encroachPositions[posnIndex].inPosition = false;;
        c.StageOrder_TakeUpPosition( encroachPositions[posnIndex].pos );
        DebugLog( "Sending" @ c @ "to" @ encroachPositions[posnIndex].pos );
    }
    else {
        // else assign agent something generic to do...
        DebugLog( "No valid advance positions to start at." );
    }
}

/**
 * When agents leave the stage, update the cover point info to reflect
 * this.
 */
function leaveStage( VGSPAIController c, EReason r ) {
    local EncroachPosnInfo pos;
    super.leaveStage( c, r );
    pos = getCoverPointInfo( c );
    if ( pos != None ) {
        pos.agent      = None;
        pos.inPosition = false;
    }
}


//===========================================================================
// Implementation/helpers
//===========================================================================

/**
 * gets the coverpoint info for a particular defender.
 */
function EncroachPosnInfo getCoverPointInfo( VGSPAIController c ) {
   local int i;
   for ( i = 0; i < EncroachPositions.length; ++i ) {
       if ( EncroachPositions[i].agent == c ) {
           return EncroachPositions[i];
       }
   }
   return None;
}

/**
 * Returns the stage agent that is closest to it's current enemy.
 */
function VGSPAIController getClosestBot() {
    local VGSPAIController closestBot;
    local int i;
    local int closestDist, dist;

    closestBot  = None;
    closestDist = MAXINT;
    for ( i = 0; i < stageAgents.length; ++i ) {
        if ( stageAgents[i].controller.enemy == None ) continue;
        dist = VSize( stageAgents[i].controller.enemy.location 
                      - stageAgents[i].controller.pawn.location );
        if ( dist < closestDist ) {
            closestDist = dist;
            closestBot  = stageAgents[i].controller;
        }
    }

    return closestBot;
}

/**
 */
function PostBeginPlay() {
    local int i, numAdvPositions;
    local AdvancePosition a;
    
    super.PostBeginPlay();
    numAdvPositions = 0;
    for ( i = 0; i < StagePositions.length; ++i ) {
        a = AdvancePosition( StagePositions[i] );
        if ( a != None ) {
            EncroachPositions.length = numAdvPositions + 1;
            EncroachPositions[numAdvPositions] 
                = new(Level) class'EncroachPosnInfo';
            EncroachPositions[numAdvPositions].pos = a;
            ++numAdvPositions;
        }
    }
    //NOTE should turn this off during hibernation...
    SetMultiTimer( ENCROACH_TIMER, advanceFrequency, true );
}

/**
 */
function LogEncroachPosns() {
    local int i;
    DebugLog( "Logging encroach positions:" );
    for ( i = 0; i < encroachPositions.length; ++i ) {
        DebugLog( encroachPositions[i].pos @ encroachPositions[i].agent
                  @ encroachPositions[i].inPosition );
    }
}

/**
 */
function MultiTimer( int timerID ) {
    local int i, j;
    local EncroachPosnInfo current, next;
    
    switch ( timerID ) {

    case WACKAMOLE_TIMER:
        Log( "wack-a-mole timer went off" );
        if ( bHiding ) {
            for ( i = 0; i < StageAgents.length; ++i ) {
                StageAgents[i].controller.StageOrder_AttackTarget
                    ( Level.GetLocalPlayerController().Pawn );
            }
        }
        else {
            for ( i = 0; i < StageAgents.length; ++i ) {
                StageAgents[i].controller.StageOrder_TakeCover( None );
            }
        }
        break;

    case ENCROACH_TIMER:
        // otherwise, it's our timer...
        DebugLog( "Encroach timer went off" );
        LogEncroachPosns();
        for ( i = 0; i < encroachPositions.length; ++i ) {
            // skip agents who aren't in position yet...
            if ( encroachPositions[i].inPosition == false 
                 || encroachPositions[i].agent == None ) continue;
            current = encroachPositions[i];
            if ( current.agent.Enemy == None ) {
                current.agent.Enemy = SelectInitialEnemy();
                if ( current.agent.Enemy == None ) {
                    DebugLog( "Could not find an enemy for" @ current.agent );
                    continue;
                }
            }
            // find a better position to go to...
            for ( j = 0; j < encroachPositions.length; ++j ) {
                if ( i == j ) continue;
                next = encroachPositions[j];

                if ( encroachPositions[j].agent == None 
                     && VSize( current.pos.location 
                               - current.agent.Enemy.location ) 
                     > VSize( next.pos.location 
                              - current.agent.Enemy.location) ) {
                    DebugLog( "Sending a guy somewhere" );
                    encroachPositions[i].inPosition = false;
                    encroachPositions[j].inPosition = false;
                    encroachPositions[j].agent 
                        = encroachPositions[i].agent;
                    encroachPositions[i].agent = none;
                    encroachPositions[j].agent
                        .StageOrder_TakeUpPosition( encroachPositions[j].pos );
                    DebugLog( "Advancing" @ encroachPositions[j].agent 
                              @ "to" @ j @ encroachPositions[j].pos 
                              @ "from" @ i @ encroachPositions[i].pos );
                    return;
                }
            }
        }
        DebugLog( "Could not advance any further" );
        break;

    default:
        super.MultiTimer( timerID );
    }
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     AdvanceFrequency=3
     nextPosnIdx=-1
     ENCROACH_TIMER=-333333
     WACKAMOLE_TIMER=9671111
     Texture=Texture'DEBAIT.EncroachStageIcon'
}
