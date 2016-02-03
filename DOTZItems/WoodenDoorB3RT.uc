// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class WoodenDoorB3RT extends DOTZDoor
    implements(Smashable)
    placeable;

defaultproperties
{
     DamageCapacity=100
     DestructionEmitter=Class'BBParticles.BBPWoodenDoorB3RTD'
     DamageEffects(0)=(DamageEmitter=Class'BBParticles.BBPWoodenDoorRTDamage',DamageRequirement=90,DamageMesh=StaticMesh'DOTZSObjects.Doors.WoodenDoorB3RTB')
     DamageEffects(1)=(DamageEmitter=Class'BBParticles.BBPWoodenDoorB3RTB',DamageRequirement=75,DamageMesh=StaticMesh'DOTZSObjects.Doors.WoodenDoorB3RTC')
     DamageEffects(2)=(DamageEmitter=Class'BBParticles.BBPWoodenDoorRTDamage',DamageRequirement=40,DamageMesh=StaticMesh'DOTZSObjects.Doors.WoodenDoorB3RTD')
     DestructionSound(0)=Sound'DOTZXDestruction.Destructables.DestructablesWood1'
     DestructionSound(1)=Sound'DOTZXDestruction.Destructables.DestructablesWood2'
     DestructionSound(2)=Sound'DOTZXDestruction.Destructables.DestructablesWood3'
     DestructionSound(3)=Sound'DOTZXDestruction.Destructables.DestructablesWood4'
     LockedSound=Sound'DOTZXActionObjects.Doors.DoorLocked'
     OpeningSounds(0)=Sound'DOTZXActionObjects.Doors.DoorOpen'
     OpeningSounds(1)=Sound'DOTZXActionObjects.Doors.DoorOpen2'
     OpeningSounds(2)=Sound'DOTZXActionObjects.Doors.DoorOpen3'
     OpeningSounds(3)=Sound'DOTZXActionObjects.Doors.DoorOpen4'
     OpeningSounds(4)=Sound'DOTZXActionObjects.Doors.DoorOpen5'
     ClosingSounds(0)=Sound'DOTZXActionObjects.Doors.DoorClose2'
     ClosingSounds(1)=Sound'DOTZXActionObjects.Doors.DoorClose3'
     ClosingSounds(2)=Sound'DOTZXActionObjects.Doors.DoorClose4'
     KeyRot(1)=(Yaw=-16384)
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSObjects.Doors.WoodenDoorB3RTA'
     InitialState="TriggerToggle"
}
