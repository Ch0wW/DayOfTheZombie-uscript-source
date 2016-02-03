class BBPImpactPlant extends BBPHitFX;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         Acceleration=(Z=-900.000000)
         FadeOutStartTime=0.100000
         FadeOut=True
         MaxParticles=5
         RespawnDeadParticles=False
         AutoDestroy=True
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.250000,Max=0.250000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=2.000000,Max=6.000000))
         UniformSize=True
         Sounds(0)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletDirtImpact1',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(1)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletDirtImpact2',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(2)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletDirtImpact3',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(3)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletDirtImpact4',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=100000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Impact.straw'
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.250000,Max=0.500000)
         StartVelocityRange=(X=(Min=-150.000000,Max=150.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Max=300.000000))
         Name="SpriteEmitter1"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPImpactPlant.SpriteEmitter1'
     AutoDestroy=True
     bNoDelete=False
}
