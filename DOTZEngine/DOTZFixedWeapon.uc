// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DOTZFixedWeapon extends FixedWeapon
   hidedropdown;

simulated function PostNetBeginPlay(){
   super.PostNetBeginPlay();
   if (Level.GetLocalPlayerController().Isa('XdotzController') == false){
       AMMO_CENTER     += 40;
       AMMO_Y          += 40;
   }
}

defaultproperties
{
     iMinInaccuracy=0.050000
     HitSpread=100.000000
     FireAnim="Fire"
     ReloadAnim="Reload"
     SelectAnim="Select"
     DeselectAnim="DeSelect"
     IdleAnim="Idle"
     AccyIndicatorSize=128
     MuzzleFlashBone="Flash01"
}
