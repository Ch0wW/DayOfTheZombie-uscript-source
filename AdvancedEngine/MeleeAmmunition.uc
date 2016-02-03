// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class MeleeAmmunition extends AdvancedAmmunition;

var int AltDamageAmount;
var int StdDamageAmount;

var int AltMomentumTransfer;
var int StdMomentumTransfer;

//direction relative to the player's weapon
var vector AltMomentumDir;
var vector StdMomentumDir;

/*****************************************************************
 * ProcessTraceHitOnMat
 *****************************************************************
 */
function ProcessTraceHitOnMat(Weapon W, Actor Other, Vector HitLocation,
                         Vector HitNormal, Vector X, Vector Y, Vector Z,
                         Material HitMaterial)
{
   //set the properties for this type of swing with a melee weapon
   //(i.e. different swings do different damage)
   if (MeleeWeapon(Instigator.Weapon).bDoAltFire==true){
      DamageAmount = AltDamageAmount;
      MomentumTransfer = AltMomentumTransfer;
      HitNormal = -( AltMomentumDir ) >> W.Rotation;
   } else {
      DamageAmount = StdDamageAmount;
      MomentumTransfer = StdMomentumTransfer;
      HitNormal = -( StdMomentumDir ) >> W.Rotation;
   }
   Super.ProcessTraceHitOnMat(W,Other,HitLocation,HitNormal,X,Y,Z,HitMaterial);
}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     AltDamageAmount=20
     StdDamageAmount=10
     AltMomentumTransfer=10001
     StdMomentumTransfer=5000
     AltMomentumDir=(X=1.000000)
     StdMomentumDir=(X=1.000000)
     bInstantHit=True
}
