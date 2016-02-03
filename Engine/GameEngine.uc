// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// GameEngine: The game subsystem.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class GameEngine extends Engine
    native
    noexport
    transient;

// URL structure.
struct URL
{
    var string          Protocol,   // Protocol, i.e. "unreal" or "http".
                        Host;       // Optional hostname, i.e. "204.157.115.40" or "unreal.epicgames.com", blank if local.
    var int             Port;       // Optional host port.
    var string          Map;        // Map name, i.e. "SkyCity", default is "Index".
    var array<string>   Op;         // Options.
    var string          Portal;     // Portal to enter through, default is "".
    var int             Valid;
};

var Level           GLevel,
                    GEntry;
var PendingLevel    GPendingLevel;
var URL             LastURL;
var config array<string>    ServerActors,
                    ServerPackages;

var array<object> DummyArray;   // Do not modify
var object        DummyObject;  // Do not modify

var bool          bCheatProtection;

var config String MainMenuClass;            // Menu that appears when you first start
var config String InitialMenuClass;         // The initial menu that should appear
var config String ConnectingMenuClass;      // Menu that appears when you are connecting
var config String DisconnectMenuClass;      // Menu that appears when you are disconnected
var config String LoadingClass;             // Loading screen that appears

// if >= 0, save the current level to this slot (now that tick is done)
var int SaveToSlot;

// These two work together to support saving to named slots
var string SaveToNamed;
var string SaveTitle;
var string SaveOverNamed;
var string SaveOwner;
var bool   AutoSave;

var string LoadFromNamed;
var bool   QuickSave;

// SV: save checkpoint stuff
var string SaveCheckPointID;
var string LoadCheckPointID;

defaultproperties
{
     ServerActors(0)="IpDrv.UdpBeacon"
     ServerActors(1)="IpDrv.MasterServerUplink"
     ServerPackages(0)="GamePlay"
     CacheSizeMegs=64
}
