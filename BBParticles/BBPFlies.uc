class BBPFlies extends BBPEnvironmental;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         FadeOutStartTime=19.000000
         FadeOut=True
         FadeInEndTime=1.000000
         FadeIn=True
         StartLocationRange=(X=(Min=5.000000,Max=15.000000),Y=(Min=5.000000,Max=15.000000),Z=(Max=30.000000))
         StartLocationPolarRange=(Z=(Max=30.000000))
         UseRevolution=True
         RevolutionsPerSecondRange=(X=(Min=-0.100000,Max=0.100000),Y=(Min=-0.100000,Max=0.100000),Z=(Min=-1.000000,Max=1.000000))
         RevolutionScale(0)=(RelativeTime=0.500000,RelativeRevolution=(X=-1.000000,Y=-1.000000,Z=-1.000000))
         RevolutionScaleRepeats=3.000000
         SpinsPerSecondRange=(X=(Min=0.500000,Max=0.500000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.500000,Max=1.000000))
         UniformSize=True
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Particles.Fly'
         LifetimeRange=(Min=20.000000,Max=25.000000)
         StartVelocityRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         UseVelocityScale=True
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.500000,RelativeVelocity=(X=3.000000,Y=3.000000,Z=3.000000))
         VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScaleRepeats=3.000000
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
         Name="SpriteEmitter4"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPFlies.SpriteEmitter4'
     AutoDestroy=True
     bNoDelete=False
     bHighDetail=True
     bFullVolume=True
     AmbientSound=Sound'DOTZXScaryAmbience.BuzzingFlies'
     SoundVolume=105
     SoundOcclusion=OCCLUSION_BSP
     TransientSoundVolume=10.000000
     TransientSoundRadius=50.000000
}
