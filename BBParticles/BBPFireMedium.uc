class BBPFireMedium extends BBPFires;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter14
         Acceleration=(Z=200.000000)
         FadeOutStartTime=0.300000
         FadeOut=True
         FadeInEndTime=0.250000
         FadeIn=True
         MaxParticles=4
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
         Texture=Texture'SpecialFX.Fire.LargeFlames2'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.600000,Max=0.750000)
         StartVelocityRange=(Z=(Max=100.000000))
         Name="SpriteEmitter14"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPFireMedium.SpriteEmitter14'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter16
         Acceleration=(Z=150.000000)
         FadeOutStartTime=0.250000
         FadeOut=True
         FadeInEndTime=0.250000
         FadeIn=True
         MaxParticles=2
         StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=50.000000))
         UniformSize=True
         Texture=Texture'SpecialFX.MuzzleFlash.Fireball'
         LifetimeRange=(Min=0.600000,Max=0.750000)
         Name="SpriteEmitter16"
     End Object
     Emitters(1)=SpriteEmitter'BBParticles.BBPFireMedium.SpriteEmitter16'
     AutoDestroy=True
     bNoDelete=False
     bUnlit=False
}
