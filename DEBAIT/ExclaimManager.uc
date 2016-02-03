// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ExclaimManager - manages chatter.
 *
 * @version $Revision: #1 $
 * @author  Mike "The Rev" Horgan (mikeh@digitalextremes.com)
 * @date    Sept 2003
 */
class ExclaimManager extends Actor;


//===========================================================================
// Configurable Properties
//===========================================================================

// sound radius for exclamations, in Unreal Units.
var float ExclaimRadiusUU;
// pitch for exclamations, in case you don't like the default (1.0)
var float ExclaimPitch;
// send exclamations to the messaging system?
var bool bPostMessages;
// messaging system "type" for exclamations
var Name MsgType;
// enable debugging features
var bool bEnableDebug;

//===========================================================================
//Internal data
//===========================================================================

Enum EExclamationType
{
	EET_AcquireEnemy,
	EET_NoticeEnemy,
	EET_LostEnemy,
	EET_Pain,
	EET_Fear,
	EET_Panic,
	EET_Attacking,
	EET_FriendlyFire,
	EET_WitnessedDeath,
	EET_KilledEnemy,
	EET_WitnessedKilledEnemy
};

var VGSPAIController c;

var bool bScheduled;

struct ScheduledExclamation
{
    var EExclamationType type;	// which remark
    var float            time;	//level.timeseconds at which to play remark
};

struct MessageData
{
   var string Txt;
   var Sound  Snd;
};

var float GlobalLastExclaimTime;
var float GlobalTimeBetween;

var float LastExclaimTime[11];
var float TimeBetween[11];

var array<MessageData>  msgAcquire;
var array<MessageData>	msgNotice;
var array<MessageData>	msgLost;
var array<MessageData>	msgPain;
var array<MessageData>	msgFear;
var array<MessageData>	msgPanic;
var array<MessageData>	msgAttacking;
var array<MessageData>	msgFriendlyFire;
var array<MessageData>	msgWitnessedDeath;
var array<MessageData>	msgKilledEnemy;
var array<MessageData>	msgWitnessedKilledEnemy;


var ScheduledExclamation nextExclamation;
// handy for debugging
var string LastMsg;


/*****************************************************************
 * Init
 *****************************************************************
 */
function init(VGSPAIController ctlr)
{
    c = ctlr;
    //NOTETestPitch = RandRange(1.0, 2.0);
}


/*****************************************************************
 * Exclaim the desired remark after a delay of "delay" seconds.
 *
 * An exclaimation will be cancelled by a new remark scheduled to
 * occur before it, i.e. when the player hides, delay a second before
 * we remark, but if he becomes visible within that time the
 * "LostEnemy" remark is replaced by the "NoticeEnemy" remark
 *****************************************************************
 */
function Exclaim(EExclamationType type, float delay, optional float fOdds)
{
    local float schedTime;

    if(fOdds != 0.0 && Frand() > fOdds ) { return;  }
    delay = delay + 0.01;
    schedTime = c.Level.TimeSeconds + delay;

    // if a similar remark was already requested, leave well enough alone.
    if(bScheduled == true && type == nextExclamation.type) { return; }

    //don't schedule remarks too close together
    if ( schedTime - GlobalLastExclaimTime < GlobalTimeBetween ){ return; }

    //don't schedule similar remarks too close together
    if( ( c.currentStage != None
          && (schedTime - c.currentStage.LastExclaimTime[type]
                < TimeBetween[type]) )
          || (schedTime - LastExclaimTime[type] < TimeBetween[type] ) ) {
        return;
    }

    if( c.currentStage != None ) {
        c.currentStage.LastExclaimTime[type] = c.Level.TimeSeconds;
    } else {
        LastExclaimTime[type] = c.Level.TimeSeconds;
    }

    //schedule new remark (overriding current if it exists)
    nextExclamation.type = type;
    nextExclamation.time = schedTime;
    bScheduled = true;
    SetTimer(delay, false);
}


/*****************************************************************
 * Timer
 *****************************************************************
 */
function Timer()
{
    if(bScheduled && c != None && c.Pawn != None) {
        PlayScheduledExclamation();
    }
}


/*****************************************************************
 * PlaySchedulaedExclamation
 *****************************************************************
 */
function PlayScheduledExclamation()
{
    local int index;
    local Sound snd;
    local float timeSinceLastExclaim;
    local MessageData msg;

    GlobalLastExclaimTime = c.Level.TimeSeconds;

    if(c.currentStage != None) {
        c.currentStage.LastExclaimTime[nextExclamation.type]
            = c.Level.TimeSeconds;
        timeSinceLastExclaim = c.Level.TimeSeconds
            - c.currentStage.StageWideLastExclaimTime;
        if ( timeSinceLastExclaim >= GlobalTimeBetween ) {
            c.currentStage.StageWideLastExclaimTime = c.Level.TimeSeconds;
        }
        // too soon for more chatter
        else return;
    }
    else {
        LastExclaimTime[nextExclamation.type] = c.Level.TimeSeconds;
    }

    bScheduled = false;
    index   = GetRndMessageIndex(nextExclamation.type);
    GetMessage(nextExclamation.type, index, msg);
    lastMsg = msg.txt;
    snd = msg.snd;

    c.Pawn.PlaySound( snd, SLOT_None, 2.5*c.Pawn.TransientSoundVolume,
                       true, exclaimRadiusUU / 100, exclaimPitch );
    if ( bPostMessages ) {
        // Broadcast message to all players.
        c.Level.Game.Broadcast(c.Pawn, c.Pawn.Name $ ":" $ lastMsg, msgType );
    }
}


/*****************************************************************
 * GetMessage
 *****************************************************************
 */
function GetMessage( EExclamationType type, int index , out MessageData outMsg)
{
    if ( index < 0 ) return;

    switch(type)
    {
    case EET_AcquireEnemy:
        if ( index >= msgAcquire.length ) return;
        outMsg = msgAcquire[index];
        break;

    case EET_NoticeEnemy:
        if ( index >= msgNotice.length ) return;
        outMsg = msgNotice[index];
        break;

    case EET_LostEnemy:
        if ( index >= msgLost.length ) return;
        outMsg = msgLost[index];
        break;

    case EET_Pain:
        if ( index >= msgPain.length ) return;
        outMsg = msgPain[index];
        break;

    case EET_Fear:
        if ( index >= msgFear.length ) return;
        outMsg = msgFear[index];
        break;

    case EET_Panic:
        if ( index >= msgPanic.length ) return;
        outMsg = msgPanic[index];
        break;

    case EET_Attacking:
        if ( index >= msgAttacking.length ) return;
        outMsg = msgAttacking[index];
        break;

    case EET_FriendlyFire:
        if ( index >= msgFriendlyFire.length ) return;
        outMsg = msgFriendlyFire[index];
        break;

    case EET_WitnessedDeath:
        if ( index >= msgWitnessedDeath.length ) return;
        outMsg = msgWitnessedDeath[index];
        break;

    case EET_KilledEnemy:
        if ( index >= msgKilledEnemy.length ) return;
        outMsg = msgKilledEnemy[index];
        break;

    case EET_WitnessedKilledEnemy:
        if ( index >= msgKilledEnemy.length ) return;
        outMsg = msgWitnessedKilledEnemy[index];
        break;

    default:
    }
}


/*****************************************************************
 * GetRndMessageIndex
 *****************************************************************
 */
function int GetRndMessageIndex( EExclamationType type )
{
    switch(type)
    {
    case EET_AcquireEnemy:
        return Rand(msgAcquire.Length);
        break;

    case EET_NoticeEnemy:
        return Rand(msgNotice.Length);
        break;

    case EET_LostEnemy:
        return Rand(msgLost.Length);
        break;

    case EET_Pain:
        return Rand(msgPain.Length);
        break;

    case EET_Fear:
        return Rand(msgFear.Length);
        break;

    case EET_Panic:
        return Rand(msgPanic.Length);
        break;

    case EET_Attacking:
        return Rand(msgAttacking.Length);
        break;

    case EET_FriendlyFire:
        return Rand(msgFriendlyFire.Length);
        break;

    case EET_WitnessedDeath:
        return Rand(msgWitnessedDeath.Length);
        break;

    case EET_KilledEnemy:
        return Rand(msgKilledEnemy.Length);
        break;

    case EET_WitnessedKilledEnemy:
        return Rand(msgWitnessedKilledEnemy.Length);
        break;

    default:

    }
    return -1;
}

//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     ExclaimRadiusUU=15000.000000
     ExclaimPitch=1.000000
     MsgType="CriticalEvent"
     bEnableDebug=True
     GlobalTimeBetween=1.000000
     TimeBetween(0)=0.200000
     TimeBetween(1)=1.000000
     TimeBetween(2)=2.000000
     TimeBetween(3)=1.000000
     TimeBetween(4)=1.000000
     TimeBetween(6)=3.000000
     TimeBetween(7)=10.000000
     TimeBetween(8)=10.000000
     TimeBetween(9)=1.000000
     TimeBetween(10)=1.000000
     bHidden=True
}
