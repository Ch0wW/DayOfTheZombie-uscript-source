class BBPImpactMetal extends BBPHitFX;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         ColorScale(0)=(Color=(B=255,G=255,R=221))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=215))
         FadeOut=True
         MaxParticles=3
         RespawnDeadParticles=False
         AutoDestroy=True
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=15.000000)
         StartSizeRange=(X=(Min=0.500000,Max=1.000000))
         UniformSize=True
         InitialParticlesPerSecond=10000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Brighten
         Texture=None
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.100000,Max=0.200000)
         Name="SpriteEmitter2"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPImpactMetal.SpriteEmitter2'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter8
         UseDirectionAs=PTDU_Up
         Acceleration=(Z=-1000.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=213))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=198))
         FadeOutStartTime=-0.500000
         FadeOut=True
         MaxParticles=15
         RespawnDeadParticles=False
         AutoDestroy=True
         StartSizeRange=(X=(Min=3.500000,Max=7.000000))
         UniformSize=True
         Sounds(0)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletMetalImpact1',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(1)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletMetalImpact2',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(2)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletMetalImpact3',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=1000000.000000
         AutomaticInitialSpawning=False
         Texture=Texture'SpecialFX.Particles.rain'
         LifetimeRange=(Min=0.100000,Max=0.200000)
         StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Max=300.000000))
         Name="SpriteEmitter8"
     End Object
     Emitters(1)=SpriteEmitter'BBParticles.BBPImpactMetal.SpriteEmitter8'
     AutoDestroy=True
     bNoDelete=False
}
