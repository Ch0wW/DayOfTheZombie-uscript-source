// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/****************************************************************
 * HealthPack
 *
 * Things that you should touch to "get". They can be turned on and
 * look special.
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 ****************************************************************
 */
class HealthPack extends AdvancedHealthPack
placeable;

var localized string MsgTxt;

function DoActionableAction(Controller C){
    local string PlayerName;
    local string Msg;
    super.DoActionableAction(C);
    if (Level.NetMode == NM_ListenServer || Level.NetMode == NM_DedicatedServer
    && Level.Game.class.name == 'DOTZInvasion')
    {
         PlayerName = AdvancedPlayerController(C).PlayerReplicationInfo.GamerTag;
         Msg = PlayerName $ MsgTxt;
         Level.Game.Broadcast(C, Msg, 'Generic');
    // Level.Game.BroadcastHandler.Broadcast(none,Msg);
    }
}

//===========================================================================
// default Properties
//===========================================================================

defaultproperties
{
     MsgTxt=" took the big health!"
     HealSound=Sound'DOTZXInterface.PickupHealth'
     StaticMesh=StaticMesh'DOTZSSpecial.Pickups.HealthPack'
}
