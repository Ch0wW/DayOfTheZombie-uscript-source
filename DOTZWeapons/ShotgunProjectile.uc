// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ShotgunProjectile -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Nov 2003
 */
class ShotgunProjectile extends DOTZProjectileBase;


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
   velocity += speed * Dir;
   Super.PostBeginPlay();
}

/*****************************************************************
 * Landed
 *****************************************************************
 */
simulated function Landed( vector HitNormal ){
   HitWall( HitNormal, None );
}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     ExplosionEmitter=Class'BBParticles.BBPBulletBasicTank'
     BloodEmitter=Class'BBParticles.BBPBlood'
     Speed=25000.000000
     TossZ=20.000000
     Damage=70.000000
     DamageRadius=50.000000
     MomentumTransfer=10000.000000
     DrawType=DT_StaticMesh
     LifeSpan=0.400000
     DrawScale=0.500000
}
