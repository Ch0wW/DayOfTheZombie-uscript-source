class BBPFireMediumFade extends BBPFires;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter7
         Acceleration=(Z=200.000000)
         FadeOutStartTime=0.300000
         FadeOut=True
         FadeInEndTime=0.250000
         FadeIn=True
         MaxParticles=12
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
         StartLocationPolarRange=(X=(Min=-30.000000,Max=30.000000),Y=(Min=-30.000000,Max=30.000000),Z=(Max=10.000000))
         SpinParticles=True
         StartSpinRange=(X=(Min=0.300000,Max=0.400000))
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeSize=0.250000)
         SizeScale(1)=(RelativeTime=0.250000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=50.000000,Max=150.000000))
         UniformSize=True
         InitialParticlesPerSecond=4.000000
         AutomaticInitialSpawning=False
         Texture=Texture'SpecialFX.Fire.LargeFlames2'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.600000,Max=0.750000)
         StartVelocityRange=(Z=(Max=100.000000))
         Name="SpriteEmitter7"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPFireMediumFade.SpriteEmitter7'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter8
         Acceleration=(Z=150.000000)
         FadeOutStartTime=0.250000
         FadeOut=True
         FadeInEndTime=0.250000
         FadeIn=True
         MaxParticles=6
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=50.000000))
         UniformSize=True
         InitialParticlesPerSecond=2.000000
         AutomaticInitialSpawning=False
         Texture=Texture'SpecialFX.MuzzleFlash.Fireball'
         LifetimeRange=(Min=0.600000,Max=0.750000)
         Name="SpriteEmitter8"
     End Object
     Emitters(1)=SpriteEmitter'BBParticles.BBPFireMediumFade.SpriteEmitter8'
     AutoDestroy=True
     bNoDelete=False
     bUnlit=False
}
