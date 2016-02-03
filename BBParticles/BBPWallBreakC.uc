class BBPWallBreakC extends BBPDestruction;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         Acceleration=(Z=-100.000000)
         FadeOut=True
         MaxParticles=30
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(X=(Min=-30.000000,Max=110.000000),Z=(Max=120.000000))
         UseRotationFrom=PTRS_Actor
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=25.000000,Max=50.000000))
         UniformSize=True
         InitialParticlesPerSecond=1000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Smoke.Smoke'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=50.000000))
         Name="SpriteEmitter3"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPWallBreakC.SpriteEmitter3'
     Begin Object Class=MeshEmitter Name=MeshEmitter4
         StaticMesh=StaticMesh'DOTZSSpecial.Particles.Concrete'
         Acceleration=(Z=-1000.000000)
         MaxParticles=50
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(X=(Min=-80.000000,Max=120.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Max=100.000000))
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.050000,Max=0.800000),Y=(Min=0.050000,Max=0.800000),Z=(Min=0.050000,Max=0.800000))
         Sounds(0)=(Sound=Sound'DOTZXDestruction.Destructables.DestructablesStone1',Radius=(Min=200.000000,Max=200.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(1)=(Sound=Sound'DOTZXDestruction.Destructables.DestructablesStone2',Radius=(Min=200.000000,Max=200.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=100000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRange=(X=(Min=-500.000000,Max=500.000000),Y=(Min=-500.000000,Max=500.000000),Z=(Max=500.000000))
         Name="MeshEmitter4"
     End Object
     Emitters(1)=MeshEmitter'BBParticles.BBPWallBreakC.MeshEmitter4'
     AutoDestroy=True
     bNoDelete=False
}
