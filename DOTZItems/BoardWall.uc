// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class BoardWall extends DOTZDestructableMesh
placeable;

defaultproperties
{
     AttackLocation=(X=0.000000,Y=0.000000,Z=10.000000)
     DamageCapacity=100
     DestructionEmitter=Class'BBParticles.BBPBoardADestructC'
     DamageEffects(0)=(DamageEmitter=Class'BBParticles.BBPBoardADestructA',DamageRequirement=90,DamageMesh=StaticMesh'DOTZSIndustrial.Breakable.BoardAPieceB')
     DamageEffects(1)=(DamageEmitter=Class'BBParticles.BBPBoardADestructB',DamageRequirement=75,DamageMesh=StaticMesh'DOTZSIndustrial.Breakable.BoardAPieceD')
     DestructionSound(0)=Sound'DOTZXDestruction.Destructables.DestructablesStone2'
     DestructionSound(1)=Sound'DOTZXDestruction.Destructables.DestructablesStone2'
     StaticMesh=StaticMesh'DOTZSIndustrial.Breakable.BoardAPieceA'
     DrawScale3D=(Y=2.000000)
}
