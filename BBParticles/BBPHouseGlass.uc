class BBPHouseGlass extends BBPDestruction;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseDirectionAs=PTDU_Right
         Acceleration=(Z=-900.000000)
         DampingFactorRange=(X=(Min=0.100000,Max=0.500000),Y=(Min=0.100000,Max=0.500000),Z=(Min=0.100000,Max=0.500000))
         FadeOutStartTime=0.500000
         FadeOut=True
         MaxParticles=200
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(X=(Min=-64.000000,Max=64.000000),Z=(Min=-32.000000,Max=32.000000))
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.500000,Max=6.000000),Y=(Min=0.500000,Max=6.000000),Z=(Min=0.500000,Max=6.000000))
         Sounds(0)=(Sound=Sound'DOTZXDestruction.Destructables.DestructablesGlass1',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=2.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(1)=(Sound=Sound'DOTZXDestruction.Destructables.DestructablesGlass2',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=2.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(2)=(Sound=Sound'DOTZXDestruction.Destructables.DestructablesGlass3',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=2.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=100000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Particles.brokenglass'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Max=100.000000))
         Name="SpriteEmitter1"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPHouseGlass.SpriteEmitter1'
     AutoDestroy=True
     bNoDelete=False
     bUnlit=False
}
