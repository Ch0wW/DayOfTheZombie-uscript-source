// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class LavaVolume extends PhysicsVolume
	notplaceable;

defaultproperties
{
     bPainCausing=True
     DamagePerSec=40.000000
     DamageType=Class'Gameplay.Burned'
     FluidFriction=4.000000
     ViewFog=(X=0.585938,Y=0.195313,Z=0.078125)
     bDestructive=True
     bNoInventory=True
     bWaterVolume=True
     LocationName="in lava"
     bObsolete=True
}
