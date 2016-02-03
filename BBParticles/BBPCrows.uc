class BBPCrows extends BBPEnvironmental;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseDirectionAs=PTDU_Up
         FadeOutStartTime=19.000000
         FadeOut=True
         FadeInEndTime=1.000000
         FadeIn=True
         StartLocationRange=(X=(Min=500.000000,Max=1000.000000),Y=(Min=500.000000,Max=1000.000000),Z=(Max=100.000000))
         UseRevolution=True
         RevolutionsPerSecondRange=(Z=(Min=-0.050000,Max=0.050000))
         UseRotationFrom=PTRS_Normal
         SpinParticles=True
         StartSpinRange=(X=(Min=0.250000,Max=0.250000))
         StartSizeRange=(X=(Min=10.000000,Max=20.000000))
         UniformSize=True
         Sounds(0)=(Sound=Sound'DOTZXScaryAmbience.CrowCalls1',Radius=(Min=100.000000,Max=300.000000),Pitch=(Min=0.900000,Max=1.100000),Volume=(Min=100.000000,Max=300.000000),Probability=(Min=10.000000,Max=50.000000))
         Sounds(1)=(Sound=Sound'DOTZXScaryAmbience.CrowCalls2',Radius=(Min=100.000000,Max=300.000000),Pitch=(Min=0.900000,Max=1.100000),Volume=(Min=100.000000,Max=300.000000),Probability=(Min=10.000000,Max=50.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=0.001000,Max=0.050000)
         DrawStyle=PTDS_AlphaModulate_MightNotFogCorrectly
         Texture=Texture'SpecialFX.Particles.Birds'
         TextureUSubdivisions=2
         TextureVSubdivisions=1
         UseRandomSubdivision=True
         LifetimeRange=(Min=20.000000,Max=20.000000)
         StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=25.000000,Max=100.000000))
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
         Name="SpriteEmitter1"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPCrows.SpriteEmitter1'
     AutoDestroy=True
     bNoDelete=False
}
