class BBPBloodTrail extends BBPHitFX;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter4
         StaticMesh=StaticMesh'DOTZSSpecial.Gore.BoneShardA'
         Acceleration=(Z=-1000.000000)
         UseCollision=True
         DampingFactorRange=(X=(Min=0.100000,Max=0.100000),Y=(Min=0.100000,Max=0.100000),Z=(Min=0.300000,Max=0.300000))
         UseMaxCollisions=True
         MaxCollisions=(Min=2.000000,Max=2.000000)
         SpawnFromOtherEmitter=1
         SpawnAmount=1
         MaxParticles=1
         RespawnDeadParticles=False
         AutoDestroy=True
         InitialParticlesPerSecond=100000.000000
         AutomaticInitialSpawning=False
         Name="MeshEmitter4"
     End Object
     Emitters(0)=MeshEmitter'BBParticles.BBPBloodTrail.MeshEmitter4'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter12
         UseDirectionAs=PTDU_Normal
         ProjectionNormal=(X=1.000000,Z=0.000000)
         FadeOutStartTime=2.000000
         FadeOut=True
         FadeInEndTime=0.500000
         MaxParticles=4
         RespawnDeadParticles=False
         AutoDestroy=True
         UseRotationFrom=PTRS_Actor
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=5.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=10.000000,Max=30.000000))
         UniformSize=True
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Darken
         Texture=Texture'SpecialFX.Particles.BloodSpurt'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=6.000000,Max=8.000000)
         StartVelocityRange=(Z=(Min=0.010000,Max=0.010000))
         Name="SpriteEmitter12"
     End Object
     Emitters(1)=SpriteEmitter'BBParticles.BBPBloodTrail.SpriteEmitter12'
     AutoDestroy=True
     bNoDelete=False
}
