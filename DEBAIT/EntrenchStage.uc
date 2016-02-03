// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * EntrenchStage - agents take up defense positions and stay there,
 *    shooting at enemies when possible.
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Dec 2003
 */
class EntrenchStage extends Stage
   placeable;

#exec Texture Import File=Textures\entrench.tga Name=EntrenchStageIcon Mips=Off MASKED=1

//===========================================================================
// Editable properties
//===========================================================================


//===========================================================================
// Internal data
//===========================================================================
var Array<CoverPointInfo> DefensePositions;


//===========================================================================
// Stage Hooks
//===========================================================================

/**
 * When agents get to their positions, tell them to sit tight.
 */
function Report_InPosition( VGSPAIController c, StagePosition pos ) {
    local CoverPointInfo dPoint;
    c.StageOrder_TakeCover( pos );
    dPoint = getCoverPointInfo( c );
    if ( dPoint != None ) dPoint.inPosition = true;
}

/**
 * If a bot can't find cover, give it something generic to do...
 */
function Report_Exposed( VGSPAIController c ) {
    c.StageOrder_HoldPosition();
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
    else {
        c.StageOrder_TakeCover();
    }
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
//NOTE override so that guys don't move around too much
function StagePosition Request_ShootingPosition(VGSPAIController c) {
    return None;
    //return bestShootPositionAccordingToBot(c);
}

/**
 * returns a node that does not have Line of Sight from target, ifSuccess - 0 error(s), 0 warning(s)
 * it's not too far away from the agent's assigned position.
 **/
//NOTE override so that guys don't move around too much
function StagePosition Request_HidingPosition(VGSPAIController c) {
    return None;
    //    return Super.Request_HidingPosition( c );
}


//===========================================================================
// Implementation and helpers
//===========================================================================

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


auto state Init {

    /**
     * make sure to call initStage()!
     */
    function BeginState() {
        initStage();
    }

    //BEGIN:
    // some stages may wish to defer this until other conditions are met...
    //   GotoState( 'Engaged');
}

//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     Texture=Texture'DEBAIT.EntrenchStageIcon'
}
