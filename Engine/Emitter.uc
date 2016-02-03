// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// Emitter: An Unreal Emitter Actor.
//=============================================================================
class Emitter extends Actor
    native
    placeable;

#exec Texture Import File=Textures\S_Emitter.pcx  Name=S_Emitter Mips=Off MASKED=1


var()   export  editinline  array<ParticleEmitter>  Emitters;

var     (Global)    bool                AutoDestroy;
var     (Global)    bool                AutoReset;
var     (Global)    bool                DisableFogging;
var     (Global)    rangevector         GlobalOffsetRange;
var     (Global)    range               TimeTillResetRange;

var     transient   int                 Initialized;
var     transient   box                 BoundingBox;
var     transient   float               EmitterRadius;
var     transient   float               EmitterHeight;
var     transient   bool                ActorForcesEnabled;
var     transient   vector              GlobalOffset;
var     transient   float               TimeTillReset;
var     transient   bool                UseParticleProjectors;
var     transient   ParticleMaterial    ParticleMaterial;
var     transient   bool                DeleteParticleEmitters;

// shutdown the emitter and make it auto-destroy when the last active particle dies.
native function Kill();

simulated function UpdatePrecacheMaterials()
{
    local int i;
    for( i=0; i<Emitters.Length; i++ )
    {
        if( Emitters[i] != None )
        {
            if( Emitters[i].Texture != None )
                Level.AddPrecacheMaterial(Emitters[i].Texture);
        }
    }
}

event Trigger( Actor Other, Pawn EventInstigator )
{
    local int i;
    for( i=0; i<Emitters.Length; i++ )
    {
        if( Emitters[i] != None )
            Emitters[i].Trigger();
    }
}

defaultproperties
{
     DrawType=DT_Particle
     bNoDelete=True
     bUnlit=True
     RemoteRole=ROLE_SimulatedProxy
     Texture=Texture'Engine.S_Emitter'
     Style=STY_Particle
}
