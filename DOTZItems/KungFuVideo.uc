// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KungFuVideo extends SpecialItem;

/****************************************************************
 * DoActionableAction
 ****************************************************************
 */
function DoActionableAction(Controller C){
    super.DoActionableAction(C);
    if (DOTZPlayerControllerBase(Level.GetLocalPlayerController()).KungFuMode == false){
        DOTZPlayerControllerBase(Level.GetLocalPlayerController()).KungFu();
    } else {
        Level.GetLocalPlayerController().Pawn.GiveWeapon("DOTZWeapons.KungFuWeapon");
    }
     Level.GetLocalPlayerController().Pawn.PlaySound(ActionSound);

}

defaultproperties
{
     bStartsEnabled=True
     ActionMessage=""
     ActionSound=Sound'DOTZXInterface.PickupKungFu'
     iActionablePriority=8
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSSpecial.Pickups.KungFu'
     bHardAttach=True
     bUnlit=True
}
