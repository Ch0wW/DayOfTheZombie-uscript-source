class BBPMolotovLighter extends BBPMuzzleFlash;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter162
         Acceleration=(Z=10.000000)
         FadeOutStartTime=0.250000
         FadeOut=True
         FadeInEndTime=0.250000
         FadeIn=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=20
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationPolarRange=(X=(Min=-30.000000,Max=30.000000),Y=(Min=-30.000000,Max=30.000000),Z=(Max=10.000000))
         SpinParticles=True
         StartSpinRange=(X=(Min=0.300000,Max=0.400000))
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeSize=0.250000)
         SizeScale(1)=(RelativeTime=0.250000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=1.000000,Max=2.000000))
         UniformSize=True
         InitialParticlesPerSecond=20.000000
         AutomaticInitialSpawning=False
         Texture=Texture'SpecialFX.Fire.LargeFlames2'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.250000,Max=0.500000)
         StartVelocityRange=(X=(Max=-5.000000))
         Name="SpriteEmitter162"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPMolotovLighter.SpriteEmitter162'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter163
         Acceleration=(Z=5.000000)
         FadeOutStartTime=0.250000
         FadeOut=True
         FadeInEndTime=0.250000
         FadeIn=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=4
         RespawnDeadParticles=False
         AutoDestroy=True
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=1.000000,Max=2.000000))
         UniformSize=True
         InitialParticlesPerSecond=4.000000
         AutomaticInitialSpawning=False
         Texture=Texture'SpecialFX.MuzzleFlash.Fireball'
         LifetimeRange=(Min=0.250000,Max=0.500000)
         Name="SpriteEmitter163"
     End Object
     Emitters(1)=SpriteEmitter'BBParticles.BBPMolotovLighter.SpriteEmitter163'
     AutoDestroy=True
     bNoDelete=False
     bUnlit=False
}
