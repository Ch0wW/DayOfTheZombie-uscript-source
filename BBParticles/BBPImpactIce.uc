class BBPImpactIce extends BBPHitFX;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOutStartTime=0.100000
         FadeOut=True
         MaxParticles=100
         RespawnDeadParticles=False
         AutoDestroy=True
         UseRotationFrom=PTRS_Actor
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         UniformSize=True
         Sounds(0)=(Sound=Sound'DOTZXEnvironment.Steam3',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=160.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Brighten
         Texture=Texture'SpecialFX.Smoke.Smoke'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.250000,Max=0.500000)
         StartVelocityRange=(X=(Max=200.000000))
         VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         Name="SpriteEmitter0"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPImpactIce.SpriteEmitter0'
     AutoDestroy=True
     bNoDelete=False
     bDirectional=True
     Tag="BBPImpactIce"
}
