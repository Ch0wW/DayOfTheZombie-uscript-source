// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class Modifier extends Material
	native
	editinlinenew
	hidecategories(Material)
	abstract;

var() editinlineuse Material Material;

function Reset()
{
	if( Material != None )
		Material.Reset();
	if( FallbackMaterial != None )
		FallbackMaterial.Reset();
}

function Trigger( Actor Other, Actor EventInstigator )
{
	if( Material != None )
		Material.Trigger( Other, EventInstigator );
	if( FallbackMaterial != None )
		FallbackMaterial.Trigger( Other, EventInstigator );
}

defaultproperties
{
}