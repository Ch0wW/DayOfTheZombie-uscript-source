class BBPGibEatingB extends BBPGib;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter2
         StaticMesh=StaticMesh'DOTZSSpecial.Gore.BloodyChunk'
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         RespawnDeadParticles=False
         AutoDestroy=True
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.500000),Y=(Min=0.500000),Z=(Min=0.500000,Max=0.100000))
         InitialParticlesPerSecond=1000000.000000
         AutomaticInitialSpawning=False
         Name="MeshEmitter2"
     End Object
     Emitters(0)=MeshEmitter'BBParticles.BBPGibEatingB.MeshEmitter2'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         Acceleration=(Z=-10.000000)
         FadeOutStartTime=0.500000
         FadeOut=True
         MaxParticles=45
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-2.000000,Max=2.000000)
         SpinParticles=True
         StartSpinRange=(X=(Min=-0.050000,Max=0.050000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=5.000000,Max=10.000000))
         UniformSize=True
         InitialParticlesPerSecond=15.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Darken
         Texture=Texture'SpecialFX.Particles.BloodSpurt'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=2.000000,Max=3.000000)
         Name="SpriteEmitter0"
     End Object
     Emitters(1)=SpriteEmitter'BBParticles.BBPGibEatingB.SpriteEmitter0'
     AutoDestroy=True
     bNoDelete=False
     bHardAttach=True
}
