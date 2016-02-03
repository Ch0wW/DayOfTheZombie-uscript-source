class BBPMeleeImpactRock extends BBPHitFX;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOutStartTime=-0.250000
         FadeOut=True
         MaxParticles=3
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=8.000000)
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=4.000000,Max=8.000000))
         UniformSize=True
         Sounds(0)=(Sound=Sound'DOTZXDestruction.MeleeImpacts.MeleeDirtImpact',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=10000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Brighten
         Texture=Texture'SpecialFX.Smoke.Smoke'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRange=(Z=(Max=60.000000))
         Name="SpriteEmitter2"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPMeleeImpactRock.SpriteEmitter2'
     Begin Object Class=MeshEmitter Name=MeshEmitter5
         StaticMesh=StaticMesh'DOTZSSpecial.Particles.Concrete'
         Acceleration=(Z=-1000.000000)
         RespawnDeadParticles=False
         AutoDestroy=True
         AcceptsProjectors=True
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseRegularSizeScale=False
         StartSizeRange=(X=(Min=0.050000,Max=0.200000),Y=(Min=0.050000,Max=0.200000),Z=(Min=0.050000,Max=0.200000))
         InitialParticlesPerSecond=100000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=0.250000,Max=0.500000)
         StartVelocityRange=(X=(Min=-150.000000,Max=150.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Max=250.000000))
         Name="MeshEmitter5"
     End Object
     Emitters(1)=MeshEmitter'BBParticles.BBPMeleeImpactRock.MeshEmitter5'
     AutoDestroy=True
     bNoDelete=False
}
