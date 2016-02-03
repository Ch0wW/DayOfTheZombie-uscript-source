// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * ShotgunWeapon -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class ShotgunWeapon extends DOTZGunWeapon
    config(user);

/*****************************************************************
 *
 *****************************************************************
 */
function ProjectileFire(){
    local Vector Start, X,Y,Z;
    local Actor HitActor;
    local vector HitLocation, HitNormal;

    Owner.MakeNoise(1.0);
    GetAxes(Instigator.GetViewRotation(),X,Y,Z);
    Start = GetFireStart(X,Y,Z);
    AdjustedAim = Instigator.AdjustAim(AmmoType, Start, AimError);
    //added some effects nonsense here
    DrawTraceEffect(vect(0,0,0));

    //special case (if the guy is right in front of you!)
//    DrawdebugLine(Start, Start*750,0,255,255);
//bDrawDebug = true;
//debugstart=start;
//debugend = start + X *750;

    HitActor = Trace(HitLocation,HitNormal,Start + X*750, Start,true);

    if (HitActor !=None && Pawn(HitActor) != None){
       HitActor.TakeDamage(1000,instigator,HitLocation,X*1000,none);
    }

    AdvancedAmmunition(AmmoType).SpawnProjectileEx(Start,AdjustedAim, instigator);
}


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     PawnAnimationPackage="DOTZAHumans.3PShotgun"
     FireAnimName="ShotgunFire"
     StandIdleAnimName="ShotgunStandIdle"
     CrouchIdleAnimName="ShotgunCrouchIdle"
     HitAnimName="ShotgunHit"
     WeaponMode=WM_Single
     MuzzleFlashEmitterClass=Class'BBParticles.BBPShotgunMuzzleFlash'
     iMinInaccuracy=1.000000
     AimedOffset=(X=-9.000000,Y=-3.000000,Z=-1.000000)
     OfficialName="Shotgun"
     AmmoName=Class'DOTZWeapons.ShotGunAmmunition'
     PickupAmmoCount=4
     ReloadCount=4
     AutoSwitchPriority=6
     FireOffset=(X=23.000000,Y=4.000000)
     InventoryGroup=6
     PickupClass=Class'DOTZWeapons.ShotgunPickup'
     AttachmentClass=Class'DOTZWeapons.ShotgunAttachment'
     ItemName="Shotgun"
     Mesh=SkeletalMesh'DOTZAWeapons.shotgun'
}
