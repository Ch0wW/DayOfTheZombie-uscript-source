class BBPImpactDirt extends BBPHitFX;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         Acceleration=(Z=-500.000000)
         UseColorScale=True
         ColorScale(1)=(RelativeTime=0.100000,Color=(A=155))
         ColorScale(2)=(RelativeTime=0.500000,Color=(A=155))
         ColorScale(3)=(RelativeTime=1.000000)
         FadeOutStartTime=-0.250000
         MaxParticles=20
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=4.000000)
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=2.000000,Max=4.000000))
         UniformSize=True
         Sounds(0)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletStoneImpact1',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(1)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletStoneImpact2',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(2)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletStoneImpact3',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(3)=(Sound=Sound'DOTZXDestruction.BulletImpacts.BulletStoneImpact4',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=10000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Smoke.Smoke'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.500000,Max=0.750000)
         StartVelocityRange=(Z=(Max=500.000000))
         Name="SpriteEmitter2"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPImpactDirt.SpriteEmitter2'
     Begin Object Class=MeshEmitter Name=MeshEmitter4
         StaticMesh=StaticMesh'DOTZSSpecial.Particles.Concrete'
         Acceleration=(Z=-1000.000000)
         MaxParticles=15
         RespawnDeadParticles=False
         AutoDestroy=True
         AcceptsProjectors=True
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseRegularSizeScale=False
         StartSizeRange=(X=(Min=0.010000,Max=0.100000),Y=(Min=0.010000,Max=0.100000),Z=(Min=0.010000,Max=0.100000))
         InitialParticlesPerSecond=100000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=0.250000,Max=0.500000)
         StartVelocityRange=(X=(Min=-150.000000,Max=150.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Max=250.000000))
         Name="MeshEmitter4"
     End Object
     Emitters(1)=MeshEmitter'BBParticles.BBPImpactDirt.MeshEmitter4'
     Begin Object Class=MeshEmitter Name=MeshEmitter5
         StaticMesh=StaticMesh'DOTZSSpecial.Particles.Concrete'
         Acceleration=(Z=-1000.000000)
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationShape=PTLS_Polar
         AcceptsProjectors=True
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseRegularSizeScale=False
         StartSizeRange=(X=(Min=0.010000,Max=0.100000),Y=(Min=0.010000,Max=0.100000),Z=(Min=0.010000,Max=0.100000))
         InitialParticlesPerSecond=100000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=0.250000,Max=0.500000)
         StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=200.000000,Max=400.000000))
         UseVelocityScale=True
         VelocityScale(0)=(RelativeVelocity=(Z=1.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         Name="MeshEmitter5"
     End Object
     Emitters(2)=MeshEmitter'BBParticles.BBPImpactDirt.MeshEmitter5'
     AutoDestroy=True
     bNoDelete=False
     bDirectional=True
     Tag="BBPImpactRock"
}