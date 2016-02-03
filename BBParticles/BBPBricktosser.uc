class BBPBrickTosser extends BBPDestruction;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter31
         Acceleration=(Z=-300.000000)
         FadeOut=True
         MaxParticles=200
         RespawnDeadParticles=False
         AutoDestroy=True
         AddLocationFromOtherEmitter=4
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=70.000000,Max=70.000000))
         UniformSize=True
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Smoke.Smoke'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=1.000000,Max=1.000000)
         Name="SpriteEmitter31"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPBricktosser.SpriteEmitter31'
     Begin Object Class=MeshEmitter Name=MeshEmitter5
         StaticMesh=StaticMesh'DOTZSSpecial.Particles.Brick'
         Acceleration=(Z=-1800.000000)
         MaxParticles=100
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(X=(Min=-300.000000,Max=300.000000),Z=(Min=-600.000000,Max=600.000000))
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         SpawningSound=PTSC_LinearGlobal
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=1000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=-2000.000000,Max=2000.000000),Y=(Min=-2000.000000,Max=2000.000000),Z=(Max=2000.000000))
         Name="MeshEmitter5"
     End Object
     Emitters(1)=MeshEmitter'BBParticles.BBPBricktosser.MeshEmitter5'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter26
         FadeOut=True
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationShape=PTLS_Polar
         StartLocationPolarRange=(X=(Min=-200.000000,Max=200.000000),Z=(Min=-300.000000,Max=300.000000))
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(X=(Max=200.000000))
         UniformSize=True
         InitialParticlesPerSecond=1000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Smoke.Smoke'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=-2000.000000,Max=2000.000000),Y=(Min=-2000.000000,Max=2000.000000),Z=(Min=-2000.000000,Max=2000.000000))
         UseVelocityScale=True
         VelocityScale(0)=(RelativeTime=0.500000)
         Name="SpriteEmitter26"
     End Object
     Emitters(2)=SpriteEmitter'BBParticles.BBPBricktosser.SpriteEmitter26'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter27
         Acceleration=(Z=-400.000000)
         FadeOut=True
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(X=(Min=-250.000000,Max=250.000000),Z=(Min=-500.000000,Max=500.000000))
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=4.000000)
         UniformSize=True
         InitialParticlesPerSecond=10000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Particles.dust3'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(Y=(Min=-200.000000,Max=200.000000))
         Name="SpriteEmitter27"
     End Object
     Emitters(3)=SpriteEmitter'BBParticles.BBPBricktosser.SpriteEmitter27'
     Begin Object Class=MeshEmitter Name=MeshEmitter6
         StaticMesh=StaticMesh'DOTZSSpecial.Particles.Concrete'
         Acceleration=(Z=-2000.000000)
         MaxParticles=25
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=-600.000000,Max=600.000000))
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
         InitialParticlesPerSecond=100000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=2.000000,Max=2.000000)
         InitialDelayRange=(Max=0.200000)
         StartVelocityRange=(X=(Min=-800.000000,Max=800.000000),Y=(Min=-800.000000,Max=800.000000),Z=(Max=500.000000))
         Name="MeshEmitter6"
     End Object
     Emitters(4)=MeshEmitter'BBParticles.BBPBricktosser.MeshEmitter6'
     AutoDestroy=True
     bNoDelete=False
}
