// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// Material: Abstract material class
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class Material extends Object
	native
	hidecategories(Object)
	collapsecategories
	noexport;

#exec Texture Import File=Textures\DefaultTexture.pcx

var() Material FallbackMaterial;

var Material DefaultMaterial;
var const transient bool UseFallback;//Render device should use the fallback.
var const transient bool Validated;  //Material has been validated as renderable.

// prof ---
var() enum ESurfaceTypes
{
   EST_Default,
   EST_Rock,
   EST_Dirt,
   EST_Metal,
   EST_Wood,
   EST_Plant,
   EST_Flesh,
   EST_Ice,
   EST_Snow,
   EST_Water,
   EST_Glass,
} SurfaceType;
// --- prof

function Reset()
{
	if( FallbackMaterial != None )
		FallbackMaterial.Reset();
}

function Trigger( Actor Other, Actor EventInstigator )
{
	if( FallbackMaterial != None )
		FallbackMaterial.Trigger( Other, EventInstigator );
}

defaultproperties
{
     DefaultMaterial=Texture'Engine.DefaultTexture'
}
