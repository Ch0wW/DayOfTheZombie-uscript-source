class BBPBloodAxeSecondary extends BBPHitFX;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         MaxParticles=3
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-10.000000,Max=10.000000)
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=5.000000,Max=5.000000))
         UniformSize=True
         Sounds(0)=(Sound=Sound'DOTZXCharacters.ZombieImpactSounds.ImpactAxeSecondary',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=1000000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Darken
         Texture=Texture'SpecialFX.Particles.BloodSpurt'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.250000,Max=0.500000)
         Name="SpriteEmitter2"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPBloodAxeSecondary.SpriteEmitter2'
     Begin Object Class=MeshEmitter Name=MeshEmitter2
         StaticMesh=StaticMesh'DOTZSSpecial.Gore.BoneShardA'
         Acceleration=(Z=-10000.000000)
         UseCollision=True
         UseMaxCollisions=True
         MaxCollisions=(Min=2.000000,Max=2.000000)
         SpawnFromOtherEmitter=2
         SpawnAmount=1
         MaxParticles=3
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000))
         StartSizeRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
         InitialParticlesPerSecond=1000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Max=8.000000)
         Name="MeshEmitter2"
     End Object
     Emitters(1)=MeshEmitter'BBParticles.BBPBloodAxeSecondary.MeshEmitter2'
     AutoDestroy=True
     bNoDelete=False
}
