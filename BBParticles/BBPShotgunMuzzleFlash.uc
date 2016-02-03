class BBPShotgunMuzzleFlash extends BBPMuzzleFlash;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOutStartTime=-0.250000
         FadeOut=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         RespawnDeadParticles=False
         AutoDestroy=True
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=0.500000,RelativeSize=5.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=3.000000,Max=6.000000))
         UniformSize=True
         InitialParticlesPerSecond=100000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Brighten
         Texture=Texture'SpecialFX.Fire.Explosion'
         LifetimeRange=(Min=0.150000,Max=0.150000)
         Name="SpriteEmitter1"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPShotgunMuzzleFlash.SpriteEmitter1'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOutStartTime=-0.250000
         FadeOut=True
         MaxParticles=6
         RespawnDeadParticles=False
         AutoDestroy=True
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(X=(Min=2.000000,Max=6.000000))
         UniformSize=True
         InitialParticlesPerSecond=100000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Brighten
         Texture=Texture'SpecialFX.Smoke.Smoke'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.500000,Max=1.000000)
         StartVelocityRange=(Y=(Min=-50.000000,Max=50.000000),Z=(Min=-30.000000,Max=30.000000))
         Name="SpriteEmitter2"
     End Object
     Emitters(1)=SpriteEmitter'BBParticles.BBPShotgunMuzzleFlash.SpriteEmitter2'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         FadeOut=True
         MaxParticles=6
         RespawnDeadParticles=False
         AutoDestroy=True
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(X=(Min=4.000000,Max=8.000000))
         UniformSize=True
         InitialParticlesPerSecond=100000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Darken
         Texture=Texture'SpecialFX.Smoke.Smoke'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.500000,Max=1.000000)
         StartVelocityRange=(Y=(Min=-50.000000,Max=50.000000),Z=(Min=-30.000000,Max=30.000000))
         Name="SpriteEmitter3"
     End Object
     Emitters(2)=SpriteEmitter'BBParticles.BBPShotgunMuzzleFlash.SpriteEmitter3'
     AutoDestroy=True
     bNoDelete=False
     bHardAttach=True
}
