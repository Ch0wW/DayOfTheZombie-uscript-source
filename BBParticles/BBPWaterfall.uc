class BBPWaterfall extends BBPEnvironmental;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_UpAndNormal
         Acceleration=(Z=-1000.000000)
         FadeOutStartTime=-1.000000
         FadeOut=True
         MaxParticles=50
         AutoDestroy=True
         StartLocationRange=(Y=(Min=-50.000000,Max=50.000000),Z=(Min=-15.000000))
         UseRotationFrom=PTRS_Actor
         StartSizeRange=(X=(Min=50.000000))
         UniformSize=True
         Texture=Texture'SpecialFX.Fire.SprayFire1'
         LifetimeRange=(Min=1.000000,Max=1.500000)
         StartVelocityRange=(X=(Min=500.000000,Max=600.000000))
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
         Name="SpriteEmitter0"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPWaterfall.SpriteEmitter0'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter10
         Acceleration=(Z=50.000000)
         FadeOutStartTime=-1.000000
         FadeOut=True
         StartLocationOffset=(Z=-30.000000)
         StartLocationRange=(X=(Max=50.000000),Y=(Min=-100.000000,Max=100.000000))
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=25.000000,Max=50.000000))
         UniformSize=True
         DrawStyle=PTDS_Brighten
         Texture=Texture'SpecialFX.Smoke.Smoke'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=1.000000,Max=1.000000)
         Name="SpriteEmitter10"
     End Object
     Emitters(1)=SpriteEmitter'BBParticles.BBPWaterfall.SpriteEmitter10'
     AutoDestroy=True
     bNoDelete=False
}
