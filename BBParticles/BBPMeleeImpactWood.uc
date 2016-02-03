class BBPMeleeImpactWood extends BBPHitFX;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter2
         StaticMesh=StaticMesh'DOTZSSpecial.Particles.Woodshard'
         Acceleration=(Z=-700.000000)
         MaxParticles=8
         RespawnDeadParticles=False
         AutoDestroy=True
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Z=(Min=0.250000,Max=0.250000))
         StartSizeRange=(X=(Min=0.010000,Max=0.100000),Y=(Min=0.050000,Max=0.150000),Z=(Min=0.010000,Max=0.100000))
         Sounds(0)=(Sound=Sound'DOTZXDestruction.MeleeImpacts.MeleeWoodImpact',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=0.500000,Max=1.000000),Volume=(Min=6.000000,Max=6.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=100000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=0.250000,Max=0.500000)
         StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Max=300.000000))
         Name="MeshEmitter2"
     End Object
     Emitters(0)=MeshEmitter'BBParticles.BBPMeleeImpactWood.MeshEmitter2'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter16
         Acceleration=(Z=-20.000000)
         FadeOutStartTime=-0.250000
         FadeOut=True
         MaxParticles=3
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-2.000000,Max=2.000000)
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=2.000000,Max=4.000000))
         UniformSize=True
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=10000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'SpecialFX.Particles.dust3'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.250000,Max=0.500000)
         Name="SpriteEmitter16"
     End Object
     Emitters(1)=SpriteEmitter'BBParticles.BBPMeleeImpactWood.SpriteEmitter16'
     AutoDestroy=True
     bNoDelete=False
}
