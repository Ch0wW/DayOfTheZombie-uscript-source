// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class DynamicProjector extends Projector;

function Tick(float DeltaTime)
{
	DetachProjector();
	AttachProjector();
}

defaultproperties
{
     bDynamicAttach=True
     bStatic=False
}
