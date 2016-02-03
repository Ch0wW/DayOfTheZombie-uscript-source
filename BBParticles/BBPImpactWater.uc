class BBPImpactWater extends BBPHitFX;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter4
         StaticMesh=StaticMesh'DOTZSSpecial.Particles.splash'
         UseMeshBlendMode=False
         RenderTwoSided=True
         FadeOut=True
         MaxParticles=3
         RespawnDeadParticles=False
         AutoDestroy=True
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=0.050000,Max=0.100000),Y=(Min=0.050000,Max=0.100000),Z=(Min=0.050000,Max=0.250000))
         Sounds(0)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletWaterImpact',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=10000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=0.200000,Max=0.400000)
         Name="MeshEmitter4"
     End Object
     Emitters(0)=MeshEmitter'BBParticles.BBPImpactWater.MeshEmitter4'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseDirectionAs=PTDU_Up
         Acceleration=(Z=-300.000000)
         FadeOut=True
         RespawnDeadParticles=False
         AutoDestroy=True
         UseSizeScale=True
         UseRegularSizeScale=False
         StartSizeRange=(X=(Min=2.000000,Max=5.000000))
         UniformSize=True
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=10000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Brighten
         Texture=Texture'SpecialFX.Particles.rain'
         LifetimeRange=(Min=0.250000,Max=0.500000)
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Max=200.000000))
         Name="SpriteEmitter2"
     End Object
     Emitters(1)=SpriteEmitter'BBParticles.BBPImpactWater.SpriteEmitter2'
     AutoDestroy=True
     bNoDelete=False
}
