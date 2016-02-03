// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZZombieExclaimMgr - Vietnamese chatter
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Dec 2003
 */
class DOTZZombieExclaimMgr extends DOTZExclaimManager;


//===========================================================================
// default Properties
//===========================================================================

defaultproperties
{
     FemalemsgAcquire(0)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale01')
     FemalemsgAcquire(1)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale02')
     FemalemsgAcquire(2)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale03')
     FemalemsgAcquire(3)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale11')
     FemalemsgAcquire(4)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale12')
     FemalemsgAcquire(5)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale13')
     FemalemsgAcquire(6)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale14')
     FemalemsgAcquire(7)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale16')
     FemalemsgAcquire(8)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale17')
     FemalemsgAcquire(9)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale19')
     FemalemsgAcquire(10)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale20')
     FemalemsgAcquire(11)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale21')
     FemalemsgAcquire(12)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale22')
     FemalemsgAcquire(13)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale23')
     FemalemsgPain(0)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainFemale01')
     FemalemsgPain(1)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainFemale02')
     FemalemsgPain(2)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainFemale03')
     FemalemsgPain(3)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainFemale04')
     FemalemsgPain(4)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainFemale05')
     FemalemsgPain(5)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainFemale06')
     FemalemsgPain(6)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainFemale07')
     FemalemsgPain(7)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainFemale08')
     FemalemsgPain(8)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainFemale09')
     FemalemsgPain(9)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainFemale10')
     FemalemsgAttacking(0)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackFemale01')
     FemalemsgAttacking(1)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackFemale02')
     FemalemsgAttacking(2)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackFemale03')
     FemalemsgAttacking(3)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackFemale04')
     FemalemsgAttacking(4)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackFemale07')
     FemalemsgAttacking(5)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackFemale08')
     FemalemsgAttacking(6)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackFemale10')
     FemalemsgAttacking(7)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackFemale12')
     FemalemsgAttacking(8)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackFemale14')
     FemalemsgAttacking(9)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackFemale17')
     FemalemsgAttacking(10)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackFemale18')
     FemalemsgAttacking(11)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackFemale19')
     FemalemsgWitnessedDeath(0)=(Txt="Witness Death",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainFemale01')
     FemalemsgWitnessedDeath(1)=(Txt="Witness Death",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainFemale02')
     FemalemsgWitnessedKilledEnemy(0)=(Txt="Witness kill",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale01')
     FemalemsgWitnessedKilledEnemy(1)=(Txt="Witness kill",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale02')
     FemalemsgWitnessedKilledEnemy(2)=(Txt="Witness kill",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveFemale03')
     msgAcquire(0)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveMale01')
     msgAcquire(1)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveMale02')
     msgAcquire(2)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveMale03')
     msgAcquire(3)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveMale04')
     msgAcquire(4)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveMale06')
     msgAcquire(5)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveMale08')
     msgAcquire(6)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveMale09')
     msgAcquire(7)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveMale10')
     msgAcquire(8)=(Txt="Acquire!",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveMale11')
     msgPain(0)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainMale01')
     msgPain(1)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainMale02')
     msgPain(2)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainMale03')
     msgPain(3)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainMale04')
     msgPain(4)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainMale05')
     msgPain(5)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainMale06')
     msgPain(6)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainMale07')
     msgPain(7)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainMale08')
     msgPain(8)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainMale09')
     msgPain(9)=(Txt="Pain",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainMale10')
     msgAttacking(0)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackMale01')
     msgAttacking(1)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackMale02')
     msgAttacking(2)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackMale04')
     msgAttacking(3)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackMale05')
     msgAttacking(4)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackMale06')
     msgAttacking(5)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackMale07')
     msgAttacking(6)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackMale10')
     msgAttacking(7)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackMale11')
     msgAttacking(8)=(Txt="Attacking",Snd=Sound'DOTZXCharacters.ZombieAttackSounds.AttackMale13')
     msgWitnessedDeath(0)=(Txt="Witness Death",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainMale01')
     msgWitnessedDeath(1)=(Txt="Witness Death",Snd=Sound'DOTZXCharacters.ZombiePainSounds.PainMale02')
     msgWitnessedKilledEnemy(0)=(Txt="Witness kill",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveMale01')
     msgWitnessedKilledEnemy(1)=(Txt="Witness kill",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveMale02')
     msgWitnessedKilledEnemy(2)=(Txt="Witness kill",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveMale03')
     msgWitnessedKilledEnemy(3)=(Txt="Witness kill",Snd=Sound'DOTZXCharacters.ZombieActivateSounds.ActiveMale04')
}
