// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZMediumWeapon - base class for all ranged weapons in DOTZ.
 *
 * @version $Rev: 5372 $
 * @author  Jesse LaChapelle (jesse@digitalextremes.com)
 * @date    May 2004
 */
class DOTZGunWeapon extends RangedWeapon;

simulated function PostNetBeginPlay(){
   super.PostNetBeginPlay();
   if (Level.GetLocalPlayerController().Isa('XdotzController') == false){
       AMMO_CENTER     += 40;
       AMMO_Y          += 40;
   }
}




/**
 * Hack out the aimed mode stuff, do reload instead (but keep the key-bindings
 * as is, so that sniper rifle still works on RMB).
 */
simulated function ToggleAimedMode() {
    ForceReload();
}

simulated function AltFire( float Value ) {
   ForceReload();
   super.AltFire(Value);
}

/*****************************************************************
 * DrawToHud
 *****************************************************************
 */
simulated function DrawToHud( Canvas c, float scaleX, float scaleY ) {

/*
    if (class'DOTZGameInfoBase'.default.bUseReticule){
        AccuracyIndicator = default.AccuracyIndicator;
    } else {
        AccuracyIndicator = none;
    }
    */
    super.DrawToHud(C,scaleX,scaleY);
}

//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     EmptySound=Sound'DOTZXWeapons.Ranged.RangedGrenadeClipOff'
     bWeaponKicks=True
     iMinInaccuracy=0.050000
     HitSpread=100.000000
     FireAnim="Fire"
     ReloadAnim="Reload"
     SelectAnim="Select"
     DeselectAnim="DeSelect"
     IdleAnim="Idle"
     AccuracyIndicator=Texture'DOTZTInterface.HUD.Reticule'
     AccyIndicatorSize=128
     AmmoBackWidth=128
     AmmoBackLength=64
     AmmoBackX=1125
     AmmoBackY=875
     TraceFireBone="Flash01"
     MuzzleFlashBone="Flash01"
     BulletEjectBone="Flash02"
     bAltFireDoesntFire=True
     ReloadCount=10
     DisplayFOV=60.000000
     PlayerViewOffset=(X=20.000000,Y=4.000000,Z=-17.000000)
     BobDamping=2.200000
}
