class BBPImpactGlass extends BBPHitFX;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter12
         UseDirectionAs=PTDU_Right
         Acceleration=(Z=-1000.000000)
         FadeOutStartTime=0.100000
         FadeOut=True
         RespawnDeadParticles=False
         AutoDestroy=True
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.100000,Max=2.000000),Y=(Min=0.100000,Max=2.000000),Z=(Min=0.100000,Max=2.000000))
         Sounds(0)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletGlassImpact1',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(1)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletGlassImpact2',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(2)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletGlassImpact3',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(3)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletGlassImpact4',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(4)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletGlassImpact5',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=10000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Particles.brokenglass'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.250000,Max=0.250000)
         StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-50.000000,Max=200.000000))
         Name="SpriteEmitter12"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPImpactGlass.SpriteEmitter12'
     AutoDestroy=True
     bNoDelete=False
}
