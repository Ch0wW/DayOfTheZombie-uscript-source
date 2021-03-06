class BBPFireSmallFade extends BBPFires;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter10
         Acceleration=(Z=175.000000)
         FadeOutStartTime=0.250000
         FadeOut=True
         FadeInEndTime=0.250000
         FadeIn=True
         MaxParticles=18
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000))
         StartLocationPolarRange=(X=(Min=-30.000000,Max=30.000000),Y=(Min=-30.000000,Max=30.000000),Z=(Max=10.000000))
         SpinParticles=True
         StartSpinRange=(X=(Min=0.300000,Max=0.400000))
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeSize=0.250000)
         SizeScale(1)=(RelativeTime=0.250000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=25.000000,Max=50.000000))
         UniformSize=True
         InitialParticlesPerSecond=6.000000
         AutomaticInitialSpawning=False
         Texture=Texture'SpecialFX.Fire.LargeFlames2'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.600000,Max=0.750000)
         StartVelocityRange=(Z=(Max=50.000000))
         Name="SpriteEmitter10"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPFireSmallFade.SpriteEmitter10'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter11
         Acceleration=(Z=100.000000)
         FadeOutStartTime=0.250000
         FadeOut=True
         FadeInEndTime=0.250000
         FadeIn=True
         MaxParticles=6
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000))
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=30.000000,Max=60.000000))
         UniformSize=True
         InitialParticlesPerSecond=2.000000
         AutomaticInitialSpawning=False
         Texture=Texture'SpecialFX.MuzzleFlash.Fireball'
         LifetimeRange=(Min=0.600000,Max=0.750000)
         Name="SpriteEmitter11"
     End Object
     Emitters(1)=SpriteEmitter'BBParticles.BBPFireSmallFade.SpriteEmitter11'
     AutoDestroy=True
     bNoDelete=False
     bUnlit=False
}
