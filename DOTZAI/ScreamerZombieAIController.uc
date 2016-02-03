// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ScreamerZombieAIController -
 *
 * @version $Rev$
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    July 2004
 */
class ScreamerZombieAIController extends ZombieAIController;

/**
 * Override to ensure that the combat timer is not going off!
 */
function Timer() {
    // no-op
}

/**
 * Likewise, for good measure.
 */
function TimedFireWeaponAtEnemy() {
    // no-op
}


//===============================================================
// DefaultProperties
//===============================================================

defaultproperties
{
     DefaultWeaponType="XDOTZCharacters.ZombieScreamWeapon"
     AIType=Class'DOTZAI.ScreamerAIRole'
}
