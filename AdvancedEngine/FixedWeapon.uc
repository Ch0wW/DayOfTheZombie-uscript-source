// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class FixedWeapon extends RangedWeapon
   hidedropdown;


simulated function ToggleAimedMode() {
}

simulated function AltFire( float Value ) {
   super.AltFire(Value);
}

defaultproperties
{
     InventoryGroup=0
}
