class BBPFirePawn extends BBPFires;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         Acceleration=(Z=175.000000)
         FadeOutStartTime=0.250000
         FadeOut=True
         FadeInEndTime=0.250000
         FadeIn=True
         MaxParticles=12
         AutoDestroy=True
         StartLocationRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-20.000000,Max=69.000000))
         StartLocationPolarRange=(X=(Min=-30.000000,Max=30.000000),Y=(Min=-30.000000,Max=30.000000),Z=(Max=10.000000))
         SpinParticles=True
         StartSpinRange=(X=(Min=0.300000,Max=0.400000))
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeSize=0.250000)
         SizeScale(1)=(RelativeTime=0.250000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=20.000000,Max=40.000000))
         UniformSize=True
         Texture=Texture'SpecialFX.Fire.LargeFlames2'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.600000,Max=0.750000)
         StartVelocityRange=(Z=(Max=50.000000))
         Name="SpriteEmitter0"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPFirePawn.SpriteEmitter0'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         Acceleration=(Z=100.000000)
         FadeOutStartTime=0.250000
         FadeOut=True
         FadeInEndTime=0.250000
         FadeIn=True
         MaxParticles=12
         StartLocationRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Max=30.000000))
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=20.000000,Max=40.000000))
         UniformSize=True
         Sounds(0)=(Sound=Sound'DOTZXDestruction.Fire.FireLight2',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(1)=(Sound=Sound'DOTZXDestruction.Fire.FireLight3',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(2)=(Sound=Sound'DOTZXDestruction.Fire.FireLight7',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         Texture=Texture'SpecialFX.MuzzleFlash.Fireball'
         LifetimeRange=(Min=0.500000,Max=0.750000)
         Name="SpriteEmitter3"
     End Object
     Emitters(1)=SpriteEmitter'BBParticles.BBPFirePawn.SpriteEmitter3'
     AutoDestroy=True
     bNoDelete=False
     bUnlit=False
}
