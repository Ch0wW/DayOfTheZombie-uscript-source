// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class MaterialFactory extends Object
	abstract
	native;

var string Description;

const RF_Standalone = 0x00080000;

event Material CreateMaterial( Object InOuter, string InPackage, string InGroup, string InName );
native function ConsoleCommand(string Cmd);

defaultproperties
{
}
