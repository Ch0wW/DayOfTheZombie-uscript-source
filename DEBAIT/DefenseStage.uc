// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DefenseStage - organizes the AI in an area to defend against the
 * player's approach.
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    June 2003
 */
class DefenseStage extends Stage
  placeable;

#exec Texture Import File=Textures\DefenseTower.bmp Name=DefenseStageIcon Mips=Off MASKED=1


//=====================
// Editable properties
//=====================

// If the number of defenders drops below this number, retreat
var(Stage) int MinDefenders;
// How far (in unreal units) bots are allowed to look for better nodes
// when they have an assigned position
var(Stage) const int RoamingRange; 


//===============
// Internal data
//===============

var Array<CoverPointInfo> DefensePositions;
var bool bSetupExpired;
var const int DEF_INIT_TIMER;


//=======================
// Stage framework hooks
//=======================

/**
 * Success condition is the player has been destroyed or pushed back.
 */
function bool checkStageSuccess() {
    //NOTE need to do some real checks here!
    return super.checkStageSuccess();
}

/**
 * Failure means the stage has taken too many casualties, or the
 * player has breached the defense.
 */
function bool checkStageFailure() {
   DebugLog( "checking for fail," @ StageAgents.length $ "/" 
             $ minDefenders @ " defenders in stage" );
   return (StageAgents.length < minDefenders);
}

/**
 * in a retreat, we pass ALL agents over to the next stage.
 *
 * might be better to retreat in phases...
 */
//function Array<VGSPAIController> getAvailableAgents() {} 


//=======================
// Inter-Stage interface
//=======================




//=============================
// Controller->Stage interface
//=============================

/**
 *
 */
function Report_InPosition( VGSPAIController c, StagePosition pos ) {
    local CoverPointInfo dPoint;
    c.StageOrder_HoldPosition();
    dPoint = getCoverPointInfo( c );
    if ( dPoint != None ) dPoint.inPosition = true;
}

/**
 * When agents join, assign them a position.
 */
function joinStage( VGSPAIController c ) {
    local int pos;
    super.joinStage( c );
    pos = pickOpenDefensePosition();
    if ( pos != -1 ) {
        DefensePositions[pos].Defender   = c;
        DefensePositions[pos].inPosition = false;
        c.StageOrder_TakeUpPosition( DefensePositions[pos].Node );
    }
    // else assign agent something generic to do...
}

/**
 * When agents leave the stage, update the cover point info to reflect
 * this.
 */
function leaveStage( VGSPAIController c, EReason r ) {
    local CoverPointInfo dPoint;
    super.leaveStage( c, r );
    dPoint = getCoverPointInfo( c );
    if ( dPoint != None ) {
        dPoint.defender = None;
        dPoint.inPosition = false;
    }
}

/**
 * returns a node that provides Line of Sight to target, if it's not
 * too far away from the agent's assigned position.
 **/
function StagePosition Request_ShootingPosition(VGSPAIController c) {
    return bestShootPositionAccordingToBot(c);
}

/**
 * returns a node that does not have Line of Sight from target, ifSuccess - 0 error(s), 0 warning(s)
 * it's not too far away from the agent's assigned position.
 **/
function StagePosition Request_HidingPosition(VGSPAIController c) {
    return Super.Request_HidingPosition( c );
}


//================
// Implementation
//================

/**
 */
function PostBeginPlay() {
    local int i, numDefensePositions;
    local DefensePosition d;
    
    super.PostBeginPlay();
    numDefensePositions = 0;
    for ( i = 0; i < StagePositions.length; ++i ) {
        d = DefensePosition( StagePositions[i] );
        if ( d != None ) {
            DefensePositions[numDefensePositions] 
                = new(Level) class'CoverPointInfo';
            DefensePositions[numDefensePositions].Node = d;
            ++numDefensePositions;
        }
    }
    DebugLog( "Found " $ DefensePositions.length $ " cover points in " 
              $ StageName );
}

/**
 * gets the coverpoint info for a particular defender.
 */
function CoverPointInfo getCoverPointInfo( VGSPAIController defender ) {
   local int i;
   for ( i = 0; i < DefensePositions.length; ++i ) {
       if ( DefensePositions[i].defender == defender ) {
           return DefensePositions[i];
       }
   }
   return None;
}

/**
 * Randomly selects the index of one of the unassigned defense positions.
 */
function int pickOpenDefensePosition() {
    local Array<int> openPositions;
    local int i;
    for ( i = 0; i < defensePositions.length; ++i ) {
        if ( defensePositions[i].defender == None ) {
            openPositions.length = openPositions.length + 1;
            openPositions[openPositions.length - 1] = i;
        }
    }
    if ( openPositions.length < 1 ) return -1;
    return openPositions[Rand(openPositions.length)];
}


// State: Init - stage may not be ready to engage player yet
// ---------------------------------------------------------
auto state Init {

    /**
     */
    event MultiTimer( int timerID ) {
        if ( timerID != DEF_INIT_TIMER ) {
            Super.MultiTimer( timerID );
            return;
        }
        if ( StageAgents.length < MinDefenders ) {
            // not enough agents to man the defense, but try anyways
            MinDefenders = StageAgents.length;
        }
        GotoState( 'Defending' );
    }

    /**
     */
    function bool checkStageSuccess() {
        return false;
    }

    /**
     */
    function bool checkStageFailure() {
        return false;
    }

BEGIN:
    DebugLog( "initializing defence" );
    MinDefenders = default.MinDefenders;
    SetMultiTimer( DEF_INIT_TIMER, 30, false );
    
} // end state Init


// State: Defending - stage is defending against the player's advance
// ------------------------------------------------------------------
state Defending extends Engaged {

    /**
     */
    function BeginState() {
        super.BeginState();
        DebugLog( "starting defense" );
    }

} // end state Defending


// State: Failed - defense has failed, attempting to retreat to the
//                 failure stage.
// ----------------------------------------------------------------
state Retreating extends Failed {

} // end state Retreating


//===================
// Default Properties
//===================

defaultproperties
{
     MinDefenders=3
     RoamingRange=20000
     DEF_INIT_TIMER=123098
     Texture=Texture'DEBAIT.DefenseStageIcon'
     DrawScale=3.000000
}
