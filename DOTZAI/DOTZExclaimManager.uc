// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZExclaimManager - Marine Heavy Gunner implementation of the
 *    exclaim manager
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Dec 2003
 */
class DOTZExclaimManager extends ExclaimManager;


var array<MessageData>  FemalemsgAcquire;
var array<MessageData>	FemalemsgNotice;
var array<MessageData>	FemalemsgLost;
var array<MessageData>	FemalemsgPain;
var array<MessageData>	FemalemsgFear;
var array<MessageData>	FemalemsgPanic;
var array<MessageData>	FemalemsgAttacking;
var array<MessageData>	FemalemsgFriendlyFire;
var array<MessageData>	FemalemsgWitnessedDeath;
var array<MessageData>	FemalemsgKilledEnemy;
var array<MessageData>	FemalemsgWitnessedKilledEnemy;


/*****************************************************************
 * Init
 * Game specific logic on the sex of the thing requiring exclaimations
 *****************************************************************
 */
function init(VGSPAIController ctlr){
    super.Init(ctlr);
    if (XDOTZPawnBase(ctlr.Pawn).IsMale == false){
        //Acquire
         msgAcquire = FemaleMsgAcquire;
        //notice
        msgNotice = FemaleMsgNotice;
        //lost
        msgLost = FemaleMsgLost;
        //pain
        msgPain = FemaleMsgPain;
        //fear
        msgFear = FemaleMsgFear;
        //panic
        msgPanic = FemaleMsgPanic;
        //attacking
        msgAttacking = FemaleMsgAttacking;
        //friendly fire
        msgFriendlyFire = FemaleMsgFriendlyFire;
        //witness death
        msgWitnessedDeath = FemaleMsgWitnessedDeath;
        //killed enemy
        msgKilledEnemy = FemaleMsgKilledEnemy;
        //witness killed enemy
        msgWitnessedKilledEnemy = FemaleMsgWitnessedKilledEnemy;
    }
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     ExclaimRadiusUU=12000.000000
     bPostMessages=True
     MsgType="Exclaim"
     bEnableDebug=False
     GlobalTimeBetween=0.100000
     TimeBetween(0)=5.000000
     TimeBetween(1)=5.000000
     TimeBetween(2)=5.000000
     TimeBetween(3)=0.100000
     TimeBetween(4)=5.000000
     TimeBetween(5)=5.000000
     TimeBetween(6)=1.000000
     TimeBetween(7)=5.000000
     TimeBetween(8)=5.000000
     TimeBetween(9)=5.000000
     TimeBetween(10)=5.000000
}
