// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZAiController - base class for all AI controllers in DOTZ.
 *
 * @version $Rev: 4944 $
 * @author  Jesse LaChapelle (jesse@digitalextremes.com)
 * @date    June 2004
 */
class DOTZAiController extends VGSPAIController
   HideDropDown;

// String-pull navigation
const STRING_PULL_TIMER = 17003;
var StringPullMarker myStringPullMarker;

/*****************************************************************
 *  debug tick
 * do no debug stuff
 *****************************************************************
 */
function debugTick(float dT){

}

/****************************************************************
 * MeleeAttackSucceeded
 * Notification from the pawn that the melee attack is over!
 ****************************************************************
 */
function MeleeAttackSucceeded(){
}


/****************************************************************
 * Perform_Melee_Attack
 * An interface to the controller to get the pawn to do the melee attack
 ****************************************************************
 */
function Perform_Melee_Attack(){
}

/****************************************************************
 * Perform_Eating
 * An interface to the controller to get the pawn to do eating
 ****************************************************************
 */
function Perform_Eating(){
}

/****************************************************************
 * Perform_AISpecificTask
 * This is an interface to the controller to do it to do 'whatever
 * this controller normally does'. In the case of an eating AI
 * controller, this command tells the controller to do the eating
 * animation.
 ****************************************************************
 */
function Perform_AISpecificTask(){
}

function Touch(Actor A){
   Super.Touch(A);
}


//===========================================================================
// String pull magic from Mike H.
//===========================================================================

/**
 */
function Restart() {
    //NOTE: does this apply to our codebaes?
    Super.Restart();
    SetMultiTimer(STRING_PULL_TIMER, FRand() * 0.3 + 0.15, false);
    myStringPullMarker = Spawn(class'StringPullMarker');
    pawn.bCanCrouch=False;
}

/**
 */
function MultiTimer( int timerID ) {

    switch( timerID ) {

    case STRING_PULL_TIMER:
        HandleStringPull();
        SetMultiTimer(STRING_PULL_TIMER, FRand() * 0.3 + 0.15, false);
        break;

    default:
        Super.MultiTimer( timerID );
        break;
    }
}

function Destroyed(){
   super.Destroyed();
   if (MyStringPullMarker != none){
      MyStringPullMarker.Destroy();
   }
}

/**
 * Polled periodically to "pull the string tighter" along the path.
 */
function HandleStringPull()
{
    local int i;
    local Vector pathDir;

    if ( InLatentExecution(LATENT_MOVETOWARD) ) {
        if (MoveTarget == RouteCache[0]) {
            myStringPullMarker.SetLocation(MoveTarget.Location);
        }

        if ( (MoveTarget == RouteCache[0] || MoveTarget == myStringPullMarker)
                 && (RouteCache[1] != None) ) {
            pathDir = RouteCache[1].Location - RouteCache[0].Location;
            myStringPullMarker.SetLocation( myStringPullMarker.Location
                                                + Normal(pathDir) * 50 );
            if ( !ActorReachable(myStringPullMarker) ) {
                myStringPullMarker.SetLocation( myStringPullMarker.Location
                                                    - Normal(pathDir) * 50);
            }
            MoveTarget = myStringPullMarker;
            Focus      = MoveTarget;
            if ( ActorReachable(RouteCache[1]) )    {
                Pawn.Anchor = NavigationPoint(RouteCache[0]);
                MoveTarget  = RouteCache[1];
                myStringPullMarker.SetLocation(MoveTarget.Location);
                Focus       = MoveTarget;
                for( i = 0; i<15; i++) {
                    RouteCache[i]=RouteCache[i+1];
                }
            }
        }
    }
}


//===========================================================================
// Scripting related functions...
//===========================================================================

/**
 */
function SetNewScript(ScriptedSequence NewScript)
{
   //Now assign new script without memory leaks
   Super.SetNewScript(NewScript);
   SetEnemyReaction(0);
}

/**
 * SetEnemyReaction
 * Overridden so that the marines are not in god mode
 */
function SetEnemyReaction( int AlertnessLevel ) {
    ScriptedCombat = FOLLOWSCRIPT_IgnoreEnemies;
    if ( AlertnessLevel == 0 ) {
        ScriptedCombat = FOLLOWSCRIPT_IgnoreAllStimuli;
    }
    else bGodMode = false;

    if ( AlertnessLevel < 2 ) {
        Disable('HearNoise');
        Disable('SeePlayer');
        Disable('SeeMonster');
        Disable('NotifyBump');
    }
    else {
        Enable('HearNoise');
        Enable('SeePlayer');
        Enable('SeeMonster');
        Enable('NotifyBump');
        if ( AlertnessLevel == 2 ) {
            ScriptedCombat = FOLLOWSCRIPT_StayOnScript;
        }
        else {
            ScriptedCombat = FOLLOWSCRIPT_LeaveScriptForCombat;
        }
    }

    bGodMode = false; //if you set alertness level 0 they go into god
                      //mode for some reason.
}

/**
 * Scripting
 * These are overridden so the marines follow their scripts a little
 * more diligently
 */
state Scripting {
    //we want the marine to be a little less reactive
    function InitforNextAction() {
        bUseScriptFacing=false;
        ScriptedFocus=None;
        Super.InitForNextAction();
    }
    /*
          function SeePlayer(Pawn Seen){}
          function HearPlayer(Pawn Heard){}
          function Perform_NotEngaged_MoveToPosition(){}
          function Perform_NotEngaged_AtRest(){}
          function Perform_NotEngaged_FireAtTarget(){}
          function Perform_NotEngaged_Wander(){}
    */
}

defaultproperties
{
     bIsPlayer=False
}
