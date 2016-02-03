class BBPMolotovLight extends BBPMuzzleFlash;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter8
         Acceleration=(Z=15.000000)
         FadeOutStartTime=0.250000
         FadeOut=True
         FadeInEndTime=0.250000
         FadeIn=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=6
         AutoDestroy=True
         StartLocationPolarRange=(X=(Min=-30.000000,Max=30.000000),Y=(Min=-30.000000,Max=30.000000),Z=(Max=10.000000))
         SpinParticles=True
         StartSpinRange=(X=(Min=0.300000,Max=0.400000))
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeSize=0.250000)
         SizeScale(1)=(RelativeTime=0.250000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=2.500000,Max=5.000000))
         UniformSize=True
         Texture=Texture'SpecialFX.Fire.LargeFlames2'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.600000,Max=0.750000)
         StartVelocityRange=(X=(Max=-10.000000))
         Name="SpriteEmitter8"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPMolotovLight.SpriteEmitter8'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter9
         Acceleration=(Z=10.000000)
         FadeOutStartTime=0.250000
         FadeOut=True
         FadeInEndTime=0.250000
         FadeIn=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         AutoDestroy=True
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=2.500000,Max=5.000000))
         UniformSize=True
         Texture=Texture'SpecialFX.MuzzleFlash.Fireball'
         LifetimeRange=(Min=0.600000,Max=0.750000)
         Name="SpriteEmitter9"
     End Object
     Emitters(1)=SpriteEmitter'BBParticles.BBPMolotovLight.SpriteEmitter9'
     AutoDestroy=True
     bNoDelete=False
     bUnlit=False
}
