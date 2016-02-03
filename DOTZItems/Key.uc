// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class Key extends SpecialItem;

defaultproperties
{
     bStartsEnabled=True
     ActionMessage="Press Action to pick up this key"
     IconPositionX=190
     IconPositionY=750
     ActionSound=Sound'DOTZXInterface.PickupItem'
     iActionablePriority=8
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSObjects.Keys.SteelKey'
     bHardAttach=True
     bUnlit=True
}
