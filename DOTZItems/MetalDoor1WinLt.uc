// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class MetalDoor1WinLt extends DOTZDoor
placeable;

defaultproperties
{
     bTakesDamageFromZombies=False
     minDamageThreshold=1000
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
     KeyRot(1)=(Yaw=16384)
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSObjects.Doors.MetalDoor1WinRt'
     InitialState="TriggerToggle"
     DrawScale3D=(Y=-1.000000)
}
