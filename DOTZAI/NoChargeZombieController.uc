// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * NoChargeZombieController - same as a regular ZombieAIController, except it
 *      never tries to charge at the enemy.
 *
 * @version $Rev: 3155 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Aug 2004
 */
class NoChargeZombieController extends ZombieAIController;

/**
 */
function InitAIRole() {
    super.InitAIRole();
    ZombieAIRole( myAIRole ).bAllowedToCharge = false;
}

function bool shouldWalk() {
 return true;
}


function Perform_Eating() {
  GotoState('Eating');
}

//state Scripting{
  // function BeginState(){
    //  Log("I am in state scripting for some reason------------------------------");
//      GotoState('');
//   }
//}


//===============================================================
// Default Properties
//===============================================================

defaultproperties
{
}
