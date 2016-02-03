// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZAllyExclaimMgr - U.S. Marine chatter
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Dec 2003
 */
class DOTZHumanExclaimMgr extends DOTZExclaimManager;


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     GlobalTimeBetween=5.000000
     TimeBetween(0)=1000.000000
     TimeBetween(1)=10.000000
     TimeBetween(2)=10.000000
     TimeBetween(3)=5.000000
     TimeBetween(5)=5.500000
     TimeBetween(6)=15.000000
     TimeBetween(8)=30.000000
     TimeBetween(9)=30.000000
     TimeBetween(10)=30.000000
     msgAcquire(0)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainGrunt4')
     msgNotice(0)=(Txt="Notice enemy",Snd=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainGrunt4')
     msgLost(0)=(Txt="Lost enemy",Snd=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainGrunt4')
     msgPain(0)=(Txt="Pain",Snd=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainGrunt4')
     msgFear(0)=(Txt="Fear",Snd=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainGrunt4')
     msgPanic(0)=(Txt="Panic",Snd=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainGrunt4')
     msgAttacking(0)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainGrunt4')
     msgFriendlyFire(0)=(Txt="Friendly fire",Snd=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainGrunt4')
     msgWitnessedDeath(0)=(Txt="Witness Death",Snd=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainGrunt4')
     msgKilledEnemy(0)=(Txt="Killed Enemy",Snd=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainGrunt4')
     msgWitnessedKilledEnemy(0)=(Txt="Witness killed enemy",Snd=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainGrunt4')
}
