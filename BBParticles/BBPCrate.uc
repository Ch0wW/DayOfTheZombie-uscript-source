class BBPCrate extends BBPDestruction;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'DOTZSSpecial.Particles.Woodshard'
         Acceleration=(Z=-1000.000000)
         RespawnDeadParticles=False
         AutoDestroy=True
         MeshSpawningStaticMesh=StaticMesh'DOTZSIndustrial.Outdoor.WoodenBox'
         MeshSpawning=PTMS_Linear
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         InitialParticlesPerSecond=10000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-400.000000,Max=400.000000),Y=(Min=-400.000000,Max=400.000000),Z=(Max=500.000000))
         Name="MeshEmitter0"
     End Object
     Emitters(0)=MeshEmitter'BBParticles.BBPCrate.MeshEmitter0'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-70.000000,Max=70.000000)
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=15.000000)
         StartSizeRange=(X=(Min=5.000000,Max=10.000000))
         UniformSize=True
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=10000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Smoke.Smoke'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.500000,Max=1.000000)
         Name="SpriteEmitter2"
     End Object
     Emitters(1)=SpriteEmitter'BBParticles.BBPCrate.SpriteEmitter2'
     AutoDestroy=True
     bNoDelete=False
     bUnlit=False
}
