// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ServerQueryClient extends MasterServerLink
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

enum EQueryInterfaceCommand
{
	QI_Ping,
	QI_Rules,
	QI_Players,
	QI_RulesAndPlayers,
	QI_SmallPing,
};

enum EPingCause
{
	PC_Unknown,
	PC_Clicked,
	PC_AutoPing,
	PC_LANBroadcast,
};

var bool bLANQuery;

delegate OnReceivedPingInfo( int ListID, EPingCause PingCause, GameInfo.ServerResponseLine s );
delegate OnPingTimeout( int ListID, EPingCause PingCause );

native function PingServer( int ListID, EPingCause PingCause, string IP, int Port, EQueryInterfaceCommand Command, GameInfo.ServerResponseLine CurrentState );
native function CancelPings();

function BroadcastPingRequest()
{
	local GameInfo.ServerResponseLine Temp;
	if (class'MasterServerUplink'.default.LANServerPort >= 0)
	   PingServer( -1, PC_LANBroadcast, "BROADCAST", class'MasterServerUplink'.default.LANServerPort, QI_Ping, Temp );
}

cpptext
{
	// AActor interface
	void Destroy();
	void PostScriptDestroyed();
	// MasterServerLink interface
	UBOOL Poll( INT WaitTime );
	// ServerQueryClient interface
	void Init();

}


defaultproperties
{
}
