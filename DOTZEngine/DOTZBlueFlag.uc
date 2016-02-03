// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DOTZBlueFlag extends DOTZFlag
placeable;

defaultproperties
{
     TeamType=1
     RedTeamHasFlag(0)=Sound'DOTZXAnnouncer.CTF.CTFRedGotFlag01'
     RedTeamHasFlag(1)=Sound'DOTZXAnnouncer.CTF.CTFRedGotFlag02'
     BlueTeamHasFlag(0)=Sound'DOTZXAnnouncer.CTF.CTFBlueGotFlag01'
     BlueTeamHasFlag(1)=Sound'DOTZXAnnouncer.CTF.CTFBlueGotFlag02'
     RedTeamLostFlag(0)=Sound'DOTZXAnnouncer.CTF.CTFRedLostFlag01'
     RedTeamLostFlag(1)=Sound'DOTZXAnnouncer.CTF.CTFRedLostFlag02'
     BlueTeamLostFlag(0)=Sound'DOTZXAnnouncer.CTF.CTFBlueLostFlag01'
     BlueTeamLostFlag(1)=Sound'DOTZXAnnouncer.CTF.CTFBlueLostFlag02'
     StaticMesh=StaticMesh'DOTZSSpecial.Pickups.BlueSupplies'
}
