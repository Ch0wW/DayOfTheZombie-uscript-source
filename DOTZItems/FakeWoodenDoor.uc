// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class FakeWoodenDoor extends DOTZDestructableMesh
placeable;

defaultproperties
{
     AttackLocation=(X=0.000000,Z=10.000000)
     DamageCapacity=100
     DestructionEmitter=Class'BBParticles.BBPWoodenDoor1RTD'
     DamageEffects(0)=(DamageRequirement=90,DamageMesh=StaticMesh'DOTZSObjects.Doors.WoodenDoor1RTB')
     DamageEffects(1)=(DamageEmitter=Class'BBParticles.BBPWoodenDoor1RTB',DamageRequirement=75,DamageMesh=StaticMesh'DOTZSObjects.Doors.WoodenDoor1RTC')
     DamageEffects(2)=(DamageRequirement=40,DamageMesh=StaticMesh'DOTZSObjects.Doors.WoodenDoor1RTD')
     DestructionSound(0)=Sound'DOTZXDestruction.Destructables.DestructablesWood1'
     DestructionSound(1)=Sound'DOTZXDestruction.Destructables.DestructablesWood2'
     DestructionSound(2)=Sound'DOTZXDestruction.Destructables.DestructablesWood3'
     DestructionSound(3)=Sound'DOTZXDestruction.Destructables.DestructablesWood4'
     ActionMessage="Locked"
     ActionSound=Sound'DOTZXActionObjects.Doors.DoorLocked'
     StaticMesh=StaticMesh'DOTZSObjects.Doors.WoodenDoor1RTA'
}
