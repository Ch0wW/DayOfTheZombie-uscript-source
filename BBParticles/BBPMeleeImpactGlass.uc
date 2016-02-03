class BBPMeleeImpactGlass extends BBPHitFX;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter7
         UseDirectionAs=PTDU_Right
         Acceleration=(Z=-400.000000)
         FadeOutStartTime=0.100000
         FadeOut=True
         MaxParticles=15
         RespawnDeadParticles=False
         AutoDestroy=True
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.100000,Max=2.000000),Y=(Min=0.100000,Max=2.000000),Z=(Min=0.100000,Max=2.000000))
         Sounds(0)=(Sound=Sound'DOTZXDestruction.MeleeImpacts.MeleeGlassImpact',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=10000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Particles.brokenglass'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-50.000000,Max=200.000000))
         Name="SpriteEmitter7"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPMeleeImpactGlass.SpriteEmitter7'
     AutoDestroy=True
     bNoDelete=False
}
