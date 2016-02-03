// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DOTZMasterMountPoint extends MasterMountPoint
placeable;

const framerateID = 32432233;

function bool DoMount(Pawn PawnToMount){
    setMultiTimer(framerateID, 0.5, true);
    return super.DoMount(PawnToMount);
}

simulated function MultiTimer(int ID){
    local DOTZAIController dc;
    if (ID == framerateID)
    {
        foreach Allactors(class'DOTZEngine.DOTZAIController',dc)
        {
            dc.SetEnemyReaction(0);
        }
    }
    super.MultiTimer(ID);
}

function bool DoUnMount(){
    local DOTZAIController dc;
    setMultiTimer(framerateID, 0, false);
    foreach Allactors(class'DOTZEngine.DOTZAIController',dc)
    {
        dc.SetEnemyReaction(3);
    }

    return super.DoUnMount();
}

defaultproperties
{
     objMountWeapon=Class'DOTZWeapons.MountedWeaponA'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSWeapons.MountedWeapons.MountedWeaponA'
}
