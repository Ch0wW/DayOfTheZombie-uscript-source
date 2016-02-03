// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZAIRole - base class for all AI roles in DOTZ
 *
 * @version $Rev: 1720 $
 * @author  Jesse LaChapelle (jesse@digitalextremes.com)
 * @date    June 2004
 */
class DOTZAIRole extends AIRole;



var Actor BestAttractor;

/**
 */
function awakenSucceeded() {
    super.awakenSucceeded();
    //            // Log( self @ "awakenSucceeded" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function acquireEnemySucceeded() {
    super.acquireEnemySucceeded();
    //            // Log( self @ "acquireEnemySucceeded"  @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function NotEngagedAtRestSucceeded() {
    super.NotEngagedAtRestSucceeded();
   //            // Log( self @ "NotEngagedRestSucceeded"  @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function NotEngagedWanderSucceeded() {
    super.NotEngagedWanderSucceeded();
    //            // Log( self @ "NotEngagedWanderSucceeded"  @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function MoveToPositionSucceeded() {
    super.MoveToPositionSucceeded();
    //            // Log( self @ "MoveToPositionSucceeded"  @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function StandGroundSucceeded() {
    super.StandGroundSucceeded();
    //            // Log( self @ "StandGroundSucceeded"  @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function FireAtTargetSucceeded() {
    super.FireAtTargetSucceeded();
   //            // Log( self @ "FireAtTargetSucceeded"  @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function RecoverEnemySucceeded() {
    super.RecoverEnemySucceeded();
   //            // Log( self @ "RecoverEnemySucceeded"  @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function GetLOSSucceeded() {
    super.GetLOSSucceeded();
   //            // Log( self @ "GetLOSSucceeded" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function GetLOSFailed() {
    super.GetLOSFailed();
   //            // Log( self @ "GetLosFailed" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function HideFromEnemySucceeded() {
    super.HideFromEnemySucceeded();
   //            // Log( self @ self $ " HideFromEnemySucceeded" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function outFromCoverSucceeded() {
    super.outFromCoverSucceeded();
   //            // Log( self @ self $ " outofcoverSucceeded" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function supressionFireSucceeded() {
    super.supressionFireSucceeded();
   //            // Log( self @ "SupressionFireSucceeded" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function TakeCoverSucceeded() {
    super.TakeCoverSucceeded();
  //             // Log( self @ "TakeCoverSucceeded" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function TakeCoverFailed() {
    super.TakeCoverFailed();
   //            // Log( self @ "TakeCoverFailed" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function ChargeSucceeded() {
    super.ChargeSucceeded();
   //            // Log( self @ "ChargeSucceeded" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

function ChargeFailed() {
    super.ChargeFailed();
    //            // Log( self @ "ChargeFailed"  @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function strafeMoveSucceeded() {
    super.StrafeMoveSucceeded();
   //            // Log( self @ "strafeMoveSucceeded" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function HuntSucceeded() {
    super.HuntSucceeded();
  //             // Log( self @ "HuntSucceeded" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function PanicSucceeded() {
    super.PanicSucceeded();
   //            // Log( self @ "PanicSucceeded" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function advanceMoveSucceeded() {
    super.AdvanceMoveSucceeded();
   //            // Log( self @ "advancemoveSucceeded" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

function errorStopSucceeded() {
    super.ErrorStopSucceeded();
}

/**
 */
function takePositionFailed() {
    super.takePositionFailed();
   //            // Log( self @ "takepositionfailed" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function TakePositionSuceeded() {
    super.TakePositionSuceeded();
   //            // Log( self @ "takepositionSucceeded" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}


//===========================================================================
// Events of note, care of the controller...
//===========================================================================

/**
 */
function OnEnemyAcquired(){
    super.OnEnemyAcquired();
    //            // Log( self @ "OnEnemyAcquired" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}


/**
 */
function OnTakingDamage(Pawn Other, float Damage) {
    super.OnTakingDamage( other, damage );
}

/**
 */
function OnUnderFire() {
    super.OnUnderFire();
  //              // Log( self @ "OnUnderFire" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;

}

/**
 */
function OnLostSight() {
    super.OnLostSight();
  //             // Log( self @ "OnLostSight" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function OnRegainedSight(){
    super.OnRegainedSight();
//               // Log( self @ "OnRegainedSight" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 * Death of a friendly...
 */
function OnWitnessedDeath(){
    super.OnWitnessedDeath();
   //            // Log( self @ "OnWitnessedDeath" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 * Killed an enemy
 */
function OnWitnessedKill( Controller killer, Pawn victim ) {
    super.OnWitnessedKill( killer, victim );
   //            // Log( self @ "OnWitnessedKill" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function OnEnemyTooClose(){
    super.OnEnemyTooClose();
   //            // Log( self @ "OnEnemyTooClose" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 */
function OnEnemyTooFar(){
    super.OnEnemyTooFar();
    //            // Log( self @ "OnEnemyToFar" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

/**
 * Called whenever an enemy pawn is in sight, but not the current
 * enemy.
 */
function OnThreatSpotted( Pawn threat ){
    super.OnThreatSpotted( threat );
   //            // Log( self @ "OnThreatSpotted" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}


/**
 * Analagous to OnThreatSpotted().
 */
function OnThreatHeard( Pawn threat ){
    super.OnThreatHeard( threat );
   //             // Log( self @ "OnThreatHeard" @ "FOCUS:" @ bot.focus @ "BestAttract:" @ BestAttractor )    ;
}

defaultproperties
{
}
