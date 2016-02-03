// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * GrenadeProjectile -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Nov 2003
 */
class GrenadeProjectile extends DOTZProjectileBase;

const GRENADEID = 223232;
var int Bounced;
var sound BounceSound;


/*****************************************************************
 * PostBeginPlay
 * Give your newly spawned projectile a velocity
 *****************************************************************
 */
function PostBeginPlay()
{
   local vector Dir;

   //Give your projectile a velocity
   Dir = vector(Rotation);
   velocity = (speed * Dir) + owner.velocity;
   LocalRandSpin(12000);
   if (abs(RotationRate.Pitch)<10000){RotationRate.Pitch=10000;}
   if (abs(RotationRate.Roll)<10000) {RotationRate.Roll=10000;}
   SetMultiTimer(GRENADEID, 3, false);
   Super.PostBeginPlay();
}

/*****************************************************************
 * RandSpin
 *****************************************************************
 */
function LocalRandSpin(float spinRate)
{
   DesiredRotation = RotRand();
   RotationRate.Yaw = spinRate * 2 *FRand() - spinRate;
   RotationRate.Pitch = spinRate * 2 *FRand() - spinRate;
   RotationRate.Roll = spinRate * 2 *FRand() - spinRate;
}


/*****************************************************************
 * MultiTimer
 * Grenades explode after 3 seconds
 *****************************************************************
 */
function MultiTimer(int timerID){
    if (timerID == GRENADEID) {
        Explode(Location, vect(0,0,1));
    }
    else super.MultiTimer( timerID );
}


/*****************************************************************
 * Landed
 *****************************************************************
 */
simulated function Landed( vector HitNormal ){
      HitWall( HitNormal, None );
}

/*****************************************************************
 * HitWall
 *****************************************************************
 */
simulated function HitWall(vector HitNormal, actor Wall){

   Velocity = 0.4*((Velocity dot HitNormal) * HitNormal * -2 + Velocity);
   speed = VSize(Velocity);
   //PlaySound(ImpactSound, SLOT_Misc, 1.5,,150,,true);
   if ( Velocity.Z > 400 )
      Velocity.Z = 0.5 * (400 + Velocity.Z);
   else if ( speed < 20 )
   {
      bBounce = False;
      SetPhysics(PHYS_None);
   }
   PlaySound(BounceSound);
}

/**
 */
function ProcessTouch(Actor Other, Vector HitLocation) {}


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     BounceSound=Sound'DOTZXWeapons.Ranged.RangedGrenadeBounce'
     ExplosionEmitter=Class'BBParticles.BBPGrenadeImpact'
     Damage=250.000000
     DamageRadius=800.000000
     MomentumTransfer=80000.000000
     Physics=PHYS_Falling
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSWeapons.Ranged.GrenadeProjectile'
     bBounce=True
     bFixedRotationDir=True
     bRotateToDesired=True
     LifeSpan=3.000000
     SoundVolume=255
}
