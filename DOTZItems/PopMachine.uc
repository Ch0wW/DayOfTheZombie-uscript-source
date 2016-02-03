// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class PopMachine extends ActionableStaticMesh
placeable;

defaultproperties
{
     ActionMessage="Press Action to use pop machine"
     NumberOfUsesAllowed=15
     ActionSound=Sound'DOTZXActionObjects.SodaMachine.SodaMachine'
     ActionEmitter=Class'BBParticles.BBPPopMachine'
     EmitterAction=EA_SPAWN
     StaticMesh=StaticMesh'DOTZSObjects.Decoration.PopMachine'
     SoundOcclusion=OCCLUSION_None
}
