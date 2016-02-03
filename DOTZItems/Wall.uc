// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class Wall extends DOTZDestructableMesh
placeable;

defaultproperties
{
     AttackLocation=(X=0.000000,Y=0.000000,Z=10.000000)
     DamageCapacity=100
     DamageEffects(0)=(DamageEmitter=Class'BBParticles.BBPWallBreakA',DamageRequirement=90,DamageMesh=StaticMesh'DOTZSObjects.Walls.WallDmgB')
     DamageEffects(1)=(DamageEmitter=Class'BBParticles.BBPWallBreakB',DamageRequirement=75,DamageMesh=StaticMesh'DOTZSObjects.Walls.WallDmgC')
     DamageEffects(2)=(DamageEmitter=Class'BBParticles.BBPWallBreakC',DamageRequirement=40,DamageMesh=StaticMesh'DOTZSObjects.Walls.WallDmgD')
     bDisappearOnDestruction=False
     DestructionSound(0)=Sound'DOTZXDestruction.Destructables.DestructablesStone2'
     DestructionSound(1)=Sound'DOTZXDestruction.Destructables.DestructablesStone2'
     StaticMesh=StaticMesh'DOTZSObjects.Walls.WallDmgA'
     DrawScale3D=(Y=2.000000)
}
