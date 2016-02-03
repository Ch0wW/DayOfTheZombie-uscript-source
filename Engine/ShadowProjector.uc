// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//
//	ShadowProjector
//

class ShadowProjector extends Projector;

var() Actor					ShadowActor;
var() vector				LightDirection;
var() float					LightDistance;
var() bool					RootMotion;
var() bool					bBlobShadow;
var() bool					bShadowActive;
var ShadowBitmapMaterial	ShadowTexture;

//
//	PostBeginPlay
//

event PostBeginPlay()
{
	Super(Actor).PostBeginPlay();
}

//
//	Destroyed
//

event Destroyed()
{
	if(ShadowTexture != None)
	{
		ShadowTexture.ShadowActor = None;
		
		if(!ShadowTexture.Invalid)
			Level.ObjectPool.FreeObject(ShadowTexture);

		ShadowTexture = None;
		ProjTexture = None;
	}

	Super.Destroyed();
}

//
//	InitShadow
//

function InitShadow()
{
	local Plane		BoundingSphere;

	if(ShadowActor != None)
	{
		BoundingSphere = ShadowActor.GetRenderBoundingSphere();
		FOV = Atan(BoundingSphere.W * 2 + 160, LightDistance) * 180 / PI;

		ShadowTexture = ShadowBitmapMaterial(Level.ObjectPool.AllocateObject(class'ShadowBitmapMaterial'));
		ProjTexture = ShadowTexture;

		if(ShadowTexture != None)
		{
			SetDrawScale(LightDistance * tan(0.5 * FOV * PI / 180) / (0.5 * ShadowTexture.USize));

			ShadowTexture.Invalid = False;
			ShadowTexture.bBlobShadow = bBlobShadow;
			ShadowTexture.ShadowActor = ShadowActor;
			ShadowTexture.LightDirection = Normal(LightDirection);
			ShadowTexture.LightDistance = LightDistance;
			ShadowTexture.LightFOV = FOV;
            ShadowTexture.CullDistance = CullDistance; 

			Enable('Tick');
			UpdateShadow();
		}
		else
			Log(Name$".InitShadow: Failed to allocate texture");
	}
	else
		Log(Name$".InitShadow: No actor");
}

//
//	UpdateShadow
//

function UpdateShadow()
{
	local coords	C;

	DetachProjector(true);

	if(ShadowActor != None && !ShadowActor.bHidden && ShadowTexture != None && bShadowActive)
	{
		if(ShadowTexture.Invalid)
			Destroy();
		else
		{
			if(RootMotion && ShadowActor.DrawType == DT_Mesh && ShadowActor.Mesh != None)
			{
				C = ShadowActor.GetBoneCoords('');
				SetLocation(C.Origin);
			}
			else
				SetLocation(ShadowActor.Location + vect(0,0,5));

			SetRotation(Rotator(Normal(-LightDirection)));

			ShadowTexture.Dirty = true;
            ShadowTexture.CullDistance = CullDistance; 
            
            AttachProjector();
		}
	}
}

//
//	Tick
//

function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	UpdateShadow();
}

//
//	Default properties
//

defaultproperties
{
     bShadowActive=True
     bProjectActor=False
     bClipBSP=True
     bGradient=True
     bProjectOnAlpha=True
     bProjectOnParallelBSP=True
     bDynamicAttach=True
     bStatic=False
     bOwnerNoSee=True
     CullDistance=1200.000000
}
