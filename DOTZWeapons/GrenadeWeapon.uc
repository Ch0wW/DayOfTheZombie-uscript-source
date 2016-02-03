// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * GrenadeWeapon - a pseudo-weapon for throwing grenades by hand.
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class GrenadeWeapon extends DOTZGrenadeWeapon
    config(user);

// Manually tune to be in-synch w/ throw anim.  See also FireOffset.
var() float SpawnDelay;

// internal...
var private Rotator SpawnDir;
var private Vector  SpawnLocn;
const SPAWN_DELAY_TIMER = 4382;


/**
 * A quick hack, since the default props don't seem to be sticking.
 */
function BeginPlay() {
    super.BeginPlay();
    default.staticReticule = none;
    StaticReticule = none;
}

/**
 */
function SpawnProjectile(){
  local Vector Start, X,Y,Z;

   Owner.MakeNoise(1.0);
   GetAxes(Instigator.GetViewRotation(),X,Y,Z);
   Start = GetFireStart(X,Y,Z);
   AdjustedAim = Instigator.AdjustAim(AmmoType, Start, AimError);
   // all timer for the animation to get to the release point before
   // spawning...
   SpawnDir = AdjustedAim;
   SpawnLocn = start;
   DOTZAmmunitionBase(AmmoType).SpawnProjectileEx( SpawnLocn, SpawnDir ,Instigator);
}

/**
 * Replaces default weapon behaviour so that projectile is spawned
 * during the fire animation (instead of before).
 */
function ProjectileFire()
{
      SetMultiTimer( SPAWN_DELAY_TIMER, spawnDelay, false );
}


/*****************************************************************
 * Notify_SpawnProjectile
 * Called from the animation to let us know the best point to release the grenade
 *****************************************************************
 */
function Notify_SpawnProjectile(){
    SpawnProjectile();
}



//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     SpawnDelay=1.000000
     PawnAnimationPackage="DOTZAHumans.3PGrenade"
     FireAnimName="GrenadeFire"
     StandIdleAnimName="GrenadeStandIdle"
     CrouchIdleAnimName="GrenadeCrouchIdle"
     HitAnimName="GrenadeHit"
     WeaponMode=WM_Single
     bCanDamageSelf=True
     HitSpread=0.000000
     OfficialName="Grenades"
     AmmoName=Class'DOTZWeapons.GrenadeAmmunition'
     PickupAmmoCount=2
     ReloadCount=1
     AutoSwitchPriority=-1
     FireOffset=(X=30.000000,Y=40.000000,Z=45.000000)
     InventoryGroup=9
     PickupClass=Class'DOTZWeapons.GrenadePickup'
     AttachmentClass=Class'DOTZWeapons.GrenadeAttachment'
     ItemName="Grenades"
     Mesh=SkeletalMesh'DOTZAWeapons.grenade'
}
